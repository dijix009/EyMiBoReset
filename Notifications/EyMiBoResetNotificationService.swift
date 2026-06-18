import Foundation
@preconcurrency import UserNotifications

enum PreBreakAction {
    case snooze
    case skip
    case startBreak
}

/// Handles the "pre-break" macOS notification with action buttons.
///
/// Swift 6 note:
/// We intentionally implement the *completion-handler* UNUserNotificationCenterDelegate APIs
/// (instead of the async variants) to avoid strict-concurrency Sendable issues with
/// non-Sendable UserNotifications types.
final class EyMiBoResetNotificationService: NSObject, UNUserNotificationCenterDelegate {
    private enum IDs {
        static let category = "PRE_BREAK"
        static let request = "PRE_BREAK_REQUEST"
        static let actionSnooze = "SNOOZE"
        static let actionSkip = "SKIP"
        static let actionStartNow = "START_NOW"
    }

    private var lastSnoozeMinutesForCategory: Int?

    private let center = UNUserNotificationCenter.current()
    private var pendingHandler: (@MainActor (PreBreakAction) -> Void)?

    override init() {
        super.init()
        center.delegate = self
        // Register with defaults; we may re-register later if the snooze label changes.
        registerCategories(snoozeMinutes: 5)
        requestAuthorizationIfNeeded()
    }

    func sendPreBreakNotification(in seconds: TimeInterval = 5, snoozeMinutes: Int = 5, handler: @escaping @MainActor (PreBreakAction) -> Void) {
        pendingHandler = handler

        // Ensure the action button label matches the current snooze minutes.
        registerCategories(snoozeMinutes: max(1, snoozeMinutes))

        let secs = Int(max(1, seconds.rounded(.toNearestOrAwayFromZero)))

        let content = UNMutableNotificationContent()
        content.title = "Upcoming Break"
        content.body = "Your eye break starts in \(secs) seconds."
        content.categoryIdentifier = IDs.category
        content.sound = .default

        // Fixed identifier so a re-scheduled notification replaces the previous one and
        // cancelPreBreak() can reliably remove it.
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(secs), repeats: false)
        let request = UNNotificationRequest(identifier: IDs.request, content: content, trigger: trigger)
        center.add(request)
    }

    /// Cancels any pending/delivered pre-break notification and drops its handler.
    ///
    /// Called when the app leaves the pre-break state so a stale notification can't fire its
    /// actions (snooze/skip/start) during an active break and corrupt the state machine.
    func cancelPreBreak() {
        pendingHandler = nil
        center.removePendingNotificationRequests(withIdentifiers: [IDs.request])
        center.removeDeliveredNotifications(withIdentifiers: [IDs.request])
    }

    // MARK: - UNUserNotificationCenterDelegate (completion-handler variants)

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        defer { completionHandler() }

        let action: PreBreakAction?
        switch response.actionIdentifier {
        case IDs.actionSnooze:
            action = .snooze
        case IDs.actionSkip:
            action = .skip
        case IDs.actionStartNow:
            action = .startBreak
        case UNNotificationDefaultActionIdentifier:
            action = .startBreak
        case UNNotificationDismissActionIdentifier:
            action = nil
        default:
            action = nil
        }

        guard let action, let handler = pendingHandler else { return }
        pendingHandler = nil

        Task { @MainActor in
            handler(action)
        }
    }

    // MARK: - Private

    private func requestAuthorizationIfNeeded() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            guard settings.authorizationStatus == .notDetermined else { return }

            // Use the callback API here to avoid Swift 6 strict-concurrency warnings.
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
        }
    }

    private func registerCategories(snoozeMinutes: Int) {
        // Avoid spamming re-registration unless the label actually changes.
        if lastSnoozeMinutesForCategory == snoozeMinutes { return }
        lastSnoozeMinutesForCategory = snoozeMinutes

        let snooze = UNNotificationAction(identifier: IDs.actionSnooze, title: "Snooze \(snoozeMinutes) min", options: [])
        let skip = UNNotificationAction(identifier: IDs.actionSkip, title: "Skip", options: [])
        let start = UNNotificationAction(identifier: IDs.actionStartNow, title: "Start now", options: [])

        let category = UNNotificationCategory(
            identifier: IDs.category,
            actions: [start, snooze, skip],
            intentIdentifiers: [],
            options: []
        )

        center.setNotificationCategories([category])
    }
}
