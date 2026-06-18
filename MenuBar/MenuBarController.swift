import AppKit

@MainActor
final class MenuBarController {
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let stateMachine = BreakStateMachine()
    private let reminderService: IndependentReminderService?
    private let settings = UserSettings()

    /// Used to restart scheduling after a screen lock/unlock cycle.
    private var wasSchedulingActiveBeforeSystemLock = false
    private var breakStateBeforeSystemLock: BreakState = .idle

    var onBreakActiveChanged: ((Bool) -> Void)?

    private let menu = NSMenu()
    private let startPauseItem = NSMenuItem(title: "Start", action: #selector(toggleStartPause), keyEquivalent: "")
    private let startBreakNowItem = NSMenuItem(title: "Start break now", action: #selector(startBreakNow), keyEquivalent: "")
    private let snoozeItem = NSMenuItem(title: "Snooze", action: #selector(snooze), keyEquivalent: "")
    private let skipBreakItem = NSMenuItem(title: "Skip break", action: #selector(skipBreak), keyEquivalent: "")

    // Reminders control
    private let remindersHeaderItem = NSMenuItem(title: "Reminders", action: nil, keyEquivalent: "")
    private let remindersSnooze15Item = NSMenuItem(title: "Snooze 15 min", action: #selector(snoozeReminders15), keyEquivalent: "")
    private let remindersSnooze30Item = NSMenuItem(title: "Snooze 30 min", action: #selector(snoozeReminders30), keyEquivalent: "")
    private let remindersSnooze60Item = NSMenuItem(title: "Snooze 60 min", action: #selector(snoozeReminders60), keyEquivalent: "")
    private let remindersResumeItem = NSMenuItem(title: "Resume reminders", action: #selector(resumeReminders), keyEquivalent: "")
    private let remindersSnoozedInfoItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")

    private let nextBreakInfoItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
    private let breakStartsInfoItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")
    private let breakEndsInfoItem = NSMenuItem(title: "", action: nil, keyEquivalent: "")

    private let blinkCountdownItem = ReminderCountdownMenuItem(kind: .blink)
    private let postureCountdownItem = ReminderCountdownMenuItem(kind: .posture)
    private let waterCountdownItem = ReminderCountdownMenuItem(kind: .water)
    private let moveCountdownItem = ReminderCountdownMenuItem(kind: .move)
    private let stretchCountdownItem = ReminderCountdownMenuItem(kind: .stretch)
    private let wristCountdownItem = ReminderCountdownMenuItem(kind: .wrist)
    private let breathingCountdownItem = ReminderCountdownMenuItem(kind: .breathing)

    private var uiTimer: Timer?

    init(reminderService: IndependentReminderService? = nil) {
        self.reminderService = reminderService
        if let button = statusItem.button {
            // Initialized in refreshUI (supports icon/text modes).
            button.title = ""
        }

        menu.addItem(startPauseItem)
        menu.addItem(startBreakNowItem)
        menu.addItem(snoozeItem)
        menu.addItem(skipBreakItem)

        // Reminders controls
        menu.addItem(.separator())
        remindersHeaderItem.isEnabled = false
        menu.addItem(remindersHeaderItem)

        ;[remindersSnooze15Item, remindersSnooze30Item, remindersSnooze60Item, remindersResumeItem].forEach {
            menu.addItem($0)
        }

        remindersSnoozedInfoItem.isEnabled = false
        remindersSnoozedInfoItem.isHidden = true
        menu.addItem(remindersSnoozedInfoItem)

        // Break timing info
        menu.addItem(.separator())
        ;[nextBreakInfoItem, breakStartsInfoItem, breakEndsInfoItem].forEach { item in
            item.isEnabled = false
            item.isHidden = true
            menu.addItem(item)
        }

        // Reminders countdown (only visible when enabled)
        menu.addItem(.separator())
        ;[
            blinkCountdownItem,
            postureCountdownItem,
            waterCountdownItem,
            moveCountdownItem,
            stretchCountdownItem,
            wristCountdownItem,
            breathingCountdownItem
        ].forEach { menu.addItem($0) }

        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Settings…", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "q"))

        // Targets must be set for NSMenuItem actions to fire.
        // (Countdown/info items have no action and remain disabled.)
        menu.items.forEach { $0.target = self }
        statusItem.menu = menu

        // Update the menu bar title every second.
        // Use .common run loop mode so it keeps ticking while the status menu is open.
        let t = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.refreshUI() }
        }
        RunLoop.main.add(t, forMode: .common)
        uiTimer = t

        // Also refresh immediately on state changes.
        stateMachine.onStatusChange = { [weak self] status in
            self?.refreshUI()
            self?.onBreakActiveChanged?(status.state == .breakActive)
        }

        refreshUI()
    }

    private func refreshUI() {
        let status = stateMachine.statusForMenuBar()

        if let button = statusItem.button {
            switch settings.statusBarDisplayMode {
            case .text:
                button.image = nil
                // Optionally hide the countdown text (show only the app label).
                if settings.statusBarShowCountdownText {
                    button.title = status.title
                } else {
                    button.title = "EMB"
                }
            case .icon:
                let img = NSImage(named: "StatusBarIcon")
                img?.isTemplate = true
                button.image = img

                if settings.statusBarShowCountdownText {
                    // Convert "EMB 05:00" → "05:00" (and hide text for idle).
                    let t = status.title
                    if t == "EMB" || t == "EMB paused" {
                        button.title = ""
                    } else if t.hasPrefix("EMB ") {
                        button.title = String(t.dropFirst(4))
                    } else {
                        button.title = t
                    }
                } else {
                    button.title = ""
                }
            }
        }

        // Show only one of Start/Resume/Stop depending on state.
        switch status.state {
        case .idle:
            startPauseItem.title = "Start scheduling"
        case .paused:
            startPauseItem.title = "Resume scheduling"
        default:
            startPauseItem.title = "Stop scheduling"
        }

        // Start break now should be disabled during an active break.
        startBreakNowItem.isEnabled = status.state != .breakActive

        // Break actions visibility
        let allowSkip = stateMachine.allowSkipBreak
        snoozeItem.title = "Snooze \(stateMachine.snoozeMinutes) min"

        switch status.state {
        case .preBreak:
            snoozeItem.isHidden = false
            skipBreakItem.isHidden = !allowSkip
            snoozeItem.isEnabled = true
            skipBreakItem.isEnabled = allowSkip
        case .breakActive:
            snoozeItem.isHidden = true
            skipBreakItem.isHidden = !allowSkip
            snoozeItem.isEnabled = false

            if allowSkip {
                let until = stateMachine.secondsUntilSkipAvailable() ?? 0
                if until > 0 {
                    skipBreakItem.title = "Skip in \(until)s"
                    skipBreakItem.isEnabled = false
                } else {
                    skipBreakItem.title = "Skip break"
                    skipBreakItem.isEnabled = true
                }
            } else {
                skipBreakItem.title = "Skip break"
                skipBreakItem.isEnabled = false
            }
        default:
            snoozeItem.isHidden = true
            skipBreakItem.isHidden = true
            snoozeItem.isEnabled = false
            skipBreakItem.isEnabled = false
        }

        // Reminders snooze state
        if let until = settings.reminderSnoozeUntil, until > Date() {
            remindersResumeItem.isEnabled = true
            remindersSnoozedInfoItem.isHidden = false

            let secs = max(0, Int(until.timeIntervalSinceNow.rounded(.up)))
            remindersSnoozedInfoItem.title = "Snoozed: \(TimeFormat.mmss(secs))"
        } else {
            remindersSnoozedInfoItem.isHidden = true
        }

        // Break timing info rows
        let nextSecs = stateMachine.secondsUntilNextBreak()
        let startSecs = stateMachine.secondsUntilBreakStarts()
        let endSecs = stateMachine.secondsUntilBreakEnds()

        nextBreakInfoItem.isHidden = (nextSecs == nil)
        if let nextSecs { nextBreakInfoItem.title = "Next break in: \(TimeFormat.mmss(nextSecs))" }

        breakStartsInfoItem.isHidden = (startSecs == nil)
        if let startSecs { breakStartsInfoItem.title = "Break starts in: \(TimeFormat.mmss(startSecs))" }

        breakEndsInfoItem.isHidden = (endSecs == nil)
        if let endSecs { breakEndsInfoItem.title = "Break ends in: \(TimeFormat.mmss(endSecs))" }

        // If reminders are snoozed, disable the snooze actions.
        let remindersAreSnoozed = (settings.reminderSnoozeUntil ?? .distantPast) > Date()
        ;[remindersSnooze15Item, remindersSnooze30Item, remindersSnooze60Item].forEach { $0.isEnabled = !remindersAreSnoozed }
        remindersResumeItem.isEnabled = remindersAreSnoozed

        // Update countdown rows (only visible when enabled+scheduled AND the user chose to show them).
        blinkCountdownItem.update(secondsRemaining: settings.showBlinkCountdownInMenu ? reminderService?.secondsUntilNext(.blink) : nil)
        postureCountdownItem.update(secondsRemaining: settings.showPostureCountdownInMenu ? reminderService?.secondsUntilNext(.posture) : nil)
        waterCountdownItem.update(secondsRemaining: settings.showWaterCountdownInMenu ? reminderService?.secondsUntilNext(.water) : nil)
        moveCountdownItem.update(secondsRemaining: settings.showMoveCountdownInMenu ? reminderService?.secondsUntilNext(.move) : nil)
        stretchCountdownItem.update(secondsRemaining: settings.showStretchCountdownInMenu ? reminderService?.secondsUntilNext(.stretch) : nil)
        wristCountdownItem.update(secondsRemaining: settings.showWristCountdownInMenu ? reminderService?.secondsUntilNext(.wrist) : nil)
        breathingCountdownItem.update(secondsRemaining: settings.showBreathingCountdownInMenu ? reminderService?.secondsUntilNext(.breathing) : nil)
    }

    @objc private func toggleStartPause() {
        stateMachine.toggleStartPause()
    }

    @objc private func startBreakNow() {
        stateMachine.startBreakNow()
    }

    @objc private func snooze() {
        stateMachine.snooze()
    }

    @objc private func skipBreak() {
        stateMachine.skipBreakIfAllowed()
    }

    // MARK: - Reminder snooze

    @objc private func snoozeReminders15() {
        reminderService?.snooze(minutes: 15)
        refreshUI()
    }

    @objc private func snoozeReminders30() {
        reminderService?.snooze(minutes: 30)
        refreshUI()
    }

    @objc private func snoozeReminders60() {
        reminderService?.snooze(minutes: 60)
        refreshUI()
    }

    @objc private func resumeReminders() {
        reminderService?.resumeNow()
        refreshUI()
    }

    @objc private func openSettings() {
        SettingsWindow.show()
    }

    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }

    // MARK: - System lock/unlock

    /// Called when macOS locks the screen. We pause/stop *all* timers and hide any UI.
    func handleSystemWillLock() {
        wasSchedulingActiveBeforeSystemLock = stateMachine.isSchedulingActive
        breakStateBeforeSystemLock = stateMachine.state

        // Stop work/break timers and hide any break/pre-break UI.
        stateMachine.reset()

        // Stop reminder timers (blink/posture/water).
        reminderService?.stopAll()

        refreshUI()
    }

    /// Called when macOS unlocks the screen. We reset timers to their original durations and resume silently.
    func handleSystemDidUnlock() {
        // Reset reminder timers from zero.
        reminderService?.startAll()

        guard wasSchedulingActiveBeforeSystemLock else {
            refreshUI()
            return
        }

        // Reset to the original duration, but preserve *intent*:
        // - If the user locked mid-break, skip the break on unlock (go back to a fresh work countdown).
        // - Otherwise restart the normal scheduling countdown from full duration.
        switch breakStateBeforeSystemLock {
        case .breakActive, .countdownToResume:
            stateMachine.start()
        default:
            stateMachine.start()
        }

        refreshUI()
    }

    // MARK: - Sleep / wake

    func handleSystemWillSleep() {
        stateMachine.handleSystemWillSleep()
        // Reset reminders cleanly after sleep.
        reminderService?.stopAll()
        refreshUI()
    }

    func handleSystemDidWake() {
        stateMachine.handleSystemDidWake()
        reminderService?.startAll()
        refreshUI()
    }
}
