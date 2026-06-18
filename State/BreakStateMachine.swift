import Foundation

@MainActor
final class BreakStateMachine {
    struct Status {
        var state: BreakState
        var title: String
    }

    private(set) var state: BreakState = .idle
    private let timerService = BreakTimerService()
    private let overlayController = OverlayWindowController()
    private let preBreakPopup = PreBreakPopupWindowController()
    private let notificationService = EyMiBoResetNotificationService()
    private let settings = UserSettings()
    private let coordinator = BreakCoordinator()

    private var preBreakAutoStartTimer: DispatchSourceTimer?
    private var preBreakAutoStartFireDate: Date?
    private var breakStartDate: Date?
    private var breakEndDate: Date?

    /// Called whenever state or timing changes (for menu bar updates).
    var onStatusChange: ((Status) -> Void)?

    /// True if the user has scheduling active in any form (countdown/pre-break/break/paused/snoozed).
    /// Used for system lock/unlock behavior.
    var isSchedulingActive: Bool {
        state != .idle
    }

    func start() {
        notificationService.cancelPreBreak()
        transition(to: .countdownToBreak)
        timerService.startInterval(minutes: settings.intervalMinutes) { [weak self] in
            self?.preBreak()
        }
        emitStatus()
    }

    func reset() {
        timerService.invalidate()
        invalidatePreBreakAutoStart()
        notificationService.cancelPreBreak()
        preBreakPopup.hide()
        overlayController.hideAll()
        breakStartDate = nil
        breakEndDate = nil
        transition(to: .idle)
        emitStatus()
    }

    func startBreakNow() {
        invalidatePreBreakAutoStart()
        timerService.invalidate()
        startBreak()
        emitStatus()
    }

    func toggleStartPause() {
        switch state {
        case .idle, .paused:
            start()
        default:
            reset()
        }
    }

    // MARK: - Sleep / wake

    /// Called on system wake to ensure timers/overlays are consistent with wall-clock time.
    func handleSystemDidWake() {
        let now = Date()

        switch state {
        case .countdownToBreak, .snoozed, .paused:
            if (timerService.secondsRemaining ?? 1) <= 0 {
                preBreak()
            }

        case .preBreak:
            if (secondsUntilBreakStarts(now: now) ?? 1) <= 0 {
                startBreak()
            }

        case .breakActive:
            if (secondsUntilBreakEnds(now: now) ?? 1) <= 0 {
                overlayController.hideAll()
                breakStartDate = nil
                breakEndDate = nil
                start()
            }

        default:
            break
        }

        emitStatus()
    }

    func handleSystemWillSleep() {
        // Never leave transient UI hanging around.
        preBreakPopup.hide()
    }

    func statusForMenuBar(now: Date = Date()) -> Status {
        switch state {
        case .idle:
            return .init(state: state, title: "EMB")
        case .paused:
            return .init(state: state, title: "EMB paused")
        case .breakActive:
            let remaining = max(0, Int((breakEndDate ?? now).timeIntervalSince(now).rounded(.down)))
            return .init(state: state, title: "EMB " + TimeFormat.menuBarShort(remaining))
        default:
            if let secs = timerService.secondsRemaining {
                return .init(state: state, title: "EMB " + TimeFormat.menuBarShort(secs))
            }
            return .init(state: state, title: "EMB")
        }
    }

    private func preBreak() {
        // C (smart pause): if we should pause right now, just reschedule a short retry.
        guard coordinator.shouldProceedWithBreak() else {
            transition(to: .paused)
            timerService.startInterval(minutes: 1) { [weak self] in
                self?.preBreak()
            }
            emitStatus()
            return
        }

        transition(to: .preBreak)
        emitStatus()

        let countdown = TimeInterval(max(1, settings.preBreakCountdownSeconds))
        let snoozeMinutes = max(1, settings.snoozeMinutes)

        // Fallback: if the user ignores the notification, start the break automatically.
        schedulePreBreakAutoStart(seconds: countdown)
        emitStatus()

        // On-screen pre-break popup (primary UX).
        preBreakPopup.show(seconds: Int(countdown.rounded(.toNearestOrAwayFromZero))) { [weak self] in
            guard let self else { return }
            self.invalidatePreBreakAutoStart()
            self.preBreakPopup.hide()
            self.startBreak()
            self.emitStatus()
        } onSnooze: { [weak self] in
            guard let self else { return }
            self.invalidatePreBreakAutoStart()
            self.preBreakPopup.hide()
            self.snooze()
            self.emitStatus()
        } onSkip: { [weak self] in
            guard let self else { return }
            self.invalidatePreBreakAutoStart()
            self.preBreakPopup.hide()
            self.start()
            self.emitStatus()
        }

        // Notification Center fallback.
        notificationService.sendPreBreakNotification(in: countdown, snoozeMinutes: snoozeMinutes) { [weak self] action in
            guard let self else { return }
            // Ignore late taps once we've already left the pre-break state (e.g. the break
            // auto-started); acting now would corrupt the state machine.
            guard self.state == .preBreak else { return }
            self.invalidatePreBreakAutoStart()

            // If the user starts the break from Notification Center, also close the on-screen popup.
            self.preBreakPopup.hide()

            switch action {
            case .snooze:
                self.snooze()
            case .skip:
                self.start()
            case .startBreak:
                self.startBreak()
            }

            self.emitStatus()
        }
    }

    private func startBreak() {
        // Ensure the pre-break popup/notification never linger if the break starts automatically.
        preBreakPopup.hide()
        notificationService.cancelPreBreak()

        transition(to: .breakActive)
        breakEndDate = Date().addingTimeInterval(TimeInterval(settings.breakDuration))
        emitStatus()

        // Sound at break start
        if settings.breakSoundStartEnabled {
            SoundPlayer.shared.play(name: settings.breakSoundName, volume: settings.breakSoundVolume)
        }

        breakStartDate = Date()
        overlayController.showAll(
            duration: settings.breakDuration,
            allowSkip: settings.allowSkipBreak,
            skipAfterSeconds: settings.skipAvailableAfterSeconds,
            messageTitle: settings.breakMessageTitle,
            messageSubtitle: settings.breakMessageSubtitle,
            dimOpacity: settings.breakDimOpacity,
            blurStyle: settings.breakBlurStyle,
            showOnAllScreens: settings.showBreakOnAllScreens
        ) { [weak self] in
            guard let self else { return }

            // Sound at break end
            if self.settings.breakSoundEndEnabled {
                SoundPlayer.shared.play(name: self.settings.breakSoundName, volume: self.settings.breakSoundVolume)
            }

            self.breakStartDate = nil
            self.breakEndDate = nil
            self.start()
        }
    }

    func snooze() {
        notificationService.cancelPreBreak()
        transition(to: .snoozed)
        timerService.startInterval(minutes: max(1, settings.snoozeMinutes)) { [weak self] in
            self?.start()
        }
        emitStatus()
    }

    func skipBreakIfAllowed() {
        guard settings.allowSkipBreak else { return }
        // If we're already in a break, skip it (respecting skip-after).
        if state == .breakActive {
            overlayController.skipIfAllowed()
            return
        }

        // If we're in the pre-break countdown, treat skip as "go back to countdown".
        if state == .preBreak {
            invalidatePreBreakAutoStart()
            start()
        }
    }

    private func schedulePreBreakAutoStart(seconds: TimeInterval) {
        invalidatePreBreakAutoStart()
        preBreakAutoStartFireDate = Date().addingTimeInterval(seconds)
        let t = DispatchSource.makeTimerSource(queue: .main)
        t.schedule(deadline: .now() + seconds)
        t.setEventHandler { [weak self] in
            self?.invalidatePreBreakAutoStart()
            // If the pre-break countdown is ignored, ensure the popup is dismissed.
            self?.preBreakPopup.hide()
            self?.startBreak()
            self?.emitStatus()
        }
        t.resume()
        preBreakAutoStartTimer = t
    }

    private func invalidatePreBreakAutoStart() {
        preBreakAutoStartTimer?.cancel()
        preBreakAutoStartTimer = nil
        preBreakAutoStartFireDate = nil
    }

    private func transition(to newState: BreakState) {
        state = newState
    }

    // MARK: - Menu helpers

    var allowSkipBreak: Bool { settings.allowSkipBreak }
    var snoozeMinutes: Int { max(1, settings.snoozeMinutes) }

    /// Next scheduled break (work timer) remaining seconds.
    func secondsUntilNextBreak(now: Date = Date()) -> Int? {
        switch state {
        case .countdownToBreak, .snoozed:
            return timerService.secondsRemaining
        default:
            return nil
        }
    }

    /// Pre-break countdown remaining seconds.
    func secondsUntilBreakStarts(now: Date = Date()) -> Int? {
        guard state == .preBreak, let fire = preBreakAutoStartFireDate else { return nil }
        return max(0, Int(fire.timeIntervalSince(now).rounded(.up)))
    }

    /// Active break remaining seconds.
    func secondsUntilBreakEnds(now: Date = Date()) -> Int? {
        guard state == .breakActive else { return nil }
        let end = breakEndDate ?? now
        return max(0, Int(end.timeIntervalSince(now).rounded(.down)))
    }

    /// If skip-after is enabled, this returns the remaining seconds until Skip becomes available.
    func secondsUntilSkipAvailable(now: Date = Date()) -> Int? {
        guard state == .breakActive else { return nil }
        let required = max(0, settings.skipAvailableAfterSeconds)
        guard required > 0 else { return 0 }
        guard let start = breakStartDate else { return required }
        let elapsed = max(0, Int(now.timeIntervalSince(start).rounded(.down)))
        return max(0, required - elapsed)
    }

    private func emitStatus() {
        onStatusChange?(statusForMenuBar())
    }
}
