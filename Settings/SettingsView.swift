import SwiftUI

/// Back-compat shim: older code may still reference `SettingsView`.
/// The real settings UI is now the sidebar-based `SettingsRootView`.
struct SettingsView: View {
    var body: some View {
        SettingsRootView()
    }
}
