import AppKit
@preconcurrency import UserNotifications

/// Independent reminders that run during work time and pause during breaks.
///
/// Rules:
/// - Run during work time.
/// - Pause during breaks.
/// - Reset timers to 0 when break ends.
@MainActor
final class IndependentReminderService: NSObject {
    private let popup = ReminderPopupWindowController()

    private let settings = UserSettings()
    private var snoozeResumeTimer: DispatchSourceTimer?
    private let center = UNUserNotificationCenter.current()

    private var timers: [Reminder: DispatchSourceTimer] = [:]
    private var nextFireAt: [Reminder: Date] = [:]

    private var isBreakActive = false

    override init() {
        super.init()

        popup.onSnoozeTapped = { [weak self] in
            guard let self else { return }
            self.snooze(minutes: self.settings.reminderPopupSnoozeMinutes)
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onSettingsChanged),
            name: ReminderNotifications.settingsChanged,
            object: nil
        )

        // Notification authorization is requested once, centrally, by
        // EyMiBoResetNotificationService (which is also the UNUserNotificationCenter delegate).
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setBreakActive(_ active: Bool) {
        isBreakActive = active
        if active {
            stopAll()
        } else {
            // Reset time to zero when break ends.
            startAll()
        }
    }

    func startAll() {
        stopAll()

        if isSnoozed {
            scheduleResumeFromSnooze()
            return
        }

        for kind in Reminder.allCases {
            guard isEnabled(kind) else { continue }

            let interval = max(60, intervalSeconds(for: kind))
            nextFireAt[kind] = Date().addingTimeInterval(TimeInterval(interval))
            timers[kind] = schedule(every: interval) { [weak self] in
                Task { @MainActor in
                    self?.fire(kind)
                }
            }
        }
    }

    func stopAll() {
        for (_, t) in timers { t.cancel() }
        timers.removeAll()
        nextFireAt.removeAll()

        snoozeResumeTimer?.cancel()
        snoozeResumeTimer = nil
    }

    /// Seconds until the next reminder fires (nil if disabled/not scheduled).
    func secondsUntilNext(_ kind: Reminder) -> Int? {
        guard isEnabled(kind) else { return nil }
        guard let date = nextFireAt[kind] else { return nil }
        return max(0, Int(date.timeIntervalSinceNow.rounded(.up)))
    }

    // MARK: - Snooze

    var isSnoozed: Bool {
        guard let until = settings.reminderSnoozeUntil else { return false }
        return until > Date()
    }

    func snooze(minutes: Int) {
        let m = max(1, minutes)
        settings.setReminderSnoozeUntil(Date().addingTimeInterval(TimeInterval(m * 60)))
        stopAll()
        scheduleResumeFromSnooze()
    }

    func resumeNow() {
        settings.setReminderSnoozeUntil(nil)
        stopAll()
        if !isBreakActive {
            startAll()
        }
    }

    private func scheduleResumeFromSnooze() {
        guard let until = settings.reminderSnoozeUntil else { return }
        let delay = max(1, Int(until.timeIntervalSinceNow.rounded(.up)))

        snoozeResumeTimer?.cancel()
        let t = DispatchSource.makeTimerSource(queue: .main)
        t.schedule(deadline: .now() + .seconds(delay))
        t.setEventHandler { [weak self] in
            Task { @MainActor in
                guard let self else { return }
                self.settings.setReminderSnoozeUntil(nil)
                if !self.isBreakActive {
                    self.startAll()
                }
            }
        }
        t.resume()
        snoozeResumeTimer = t
    }

    // MARK: - Private

    @objc private func onSettingsChanged() {
        // Reset timers from zero when settings change (unless we're in a break).
        if !isBreakActive {
            startAll()
        }
    }

    private func isEnabled(_ kind: Reminder) -> Bool {
        switch kind {
        case .blink: return settings.blinkEnabled
        case .posture: return settings.postureEnabled
        case .water: return settings.waterEnabled
        case .move: return settings.moveEnabled
        case .stretch: return settings.stretchEnabled
        case .wrist: return settings.wristEnabled
        case .breathing: return settings.breathingEnabled
        }
    }

    private func intervalSeconds(for kind: Reminder) -> Int {
        switch kind {
        case .blink: return settings.blinkIntervalSeconds
        case .posture: return settings.postureIntervalSeconds
        case .water: return settings.waterIntervalSeconds
        case .move: return settings.moveIntervalSeconds
        case .stretch: return settings.stretchIntervalSeconds
        case .wrist: return settings.wristIntervalSeconds
        case .breathing: return settings.breathingIntervalSeconds
        }
    }

    private func schedule(every seconds: Int, handler: @escaping () -> Void) -> DispatchSourceTimer? {
        let s = max(60, seconds) // minimum 1 min
        let t = DispatchSource.makeTimerSource(queue: .main)
        t.schedule(deadline: .now() + .seconds(s), repeating: .seconds(s))
        t.setEventHandler(handler: handler)
        t.resume()
        return t
    }

    private func fire(_ kind: Reminder) {
        guard !isBreakActive else { return }
        guard !isSnoozed else { return }

        // Update the next-fire date first so countdown stays stable even if notification delivery is delayed.
        let interval = max(60, intervalSeconds(for: kind))
        nextFireAt[kind] = Date().addingTimeInterval(TimeInterval(interval))

        // On-screen popup (LookAway-ish).
        popup.show(title: kind.notificationTitle, subtitle: kind.notificationBody)

        // Also send a notification (kept as a fallback / for Notification Center).
        let content = UNMutableNotificationContent()
        content.title = kind.notificationTitle
        content.body = kind.notificationBody
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "reminder." + kind.identifier + "." + UUID().uuidString,
            content: content,
            trigger: nil
        )

        center.add(request)
    }
}
