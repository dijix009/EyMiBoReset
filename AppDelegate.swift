import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var menuBarController: MenuBarController?
    private let reminderService = IndependentReminderService()

    func applicationDidFinishLaunching(_ notification: Notification) {
        reminderService.startAll()
        menuBarController = MenuBarController(reminderService: reminderService)

        // Observe screen lock/unlock so we can pause all timers while locked and reset on unlock.
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(onScreenLocked),
            name: Notification.Name("com.apple.screenIsLocked"),
            object: nil
        )
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(onScreenUnlocked),
            name: Notification.Name("com.apple.screenIsUnlocked"),
            object: nil
        )

        // Wire break state changes to pause/reset independent reminders.
        menuBarController?.onBreakActiveChanged = { [weak self] active in
            self?.reminderService.setBreakActive(active)
        }

        // Sleep / wake handling (production reliability).
        let workspaceNC = NSWorkspace.shared.notificationCenter
        workspaceNC.addObserver(self, selector: #selector(onWillSleep), name: NSWorkspace.willSleepNotification, object: nil)
        workspaceNC.addObserver(self, selector: #selector(onDidWake), name: NSWorkspace.didWakeNotification, object: nil)

        // First launch: open Settings so the user can configure timers + reminders.
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "didShowInitialSetup") == false {
            defaults.set(true, forKey: "didShowInitialSetup")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                SettingsWindow.show()
            }
        }
    }

    deinit {
        DistributedNotificationCenter.default().removeObserver(self)
        NSWorkspace.shared.notificationCenter.removeObserver(self)
    }

    @objc private func onScreenLocked() {
        menuBarController?.handleSystemWillLock()
    }

    @objc private func onScreenUnlocked() {
        menuBarController?.handleSystemDidUnlock()
    }

    @objc private func onWillSleep() {
        menuBarController?.handleSystemWillSleep()
    }

    @objc private func onDidWake() {
        menuBarController?.handleSystemDidWake()
    }
}
