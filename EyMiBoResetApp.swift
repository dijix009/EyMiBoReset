import SwiftUI

@main
struct EyMiBoResetApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            SettingsRootView()
        }
    }
}
