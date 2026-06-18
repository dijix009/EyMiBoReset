import SwiftUI

struct AutomationsSettingsView: View {
    var body: some View {
        Form {
            Section {
                Text("Coming soon: run Shortcuts / AppleScript when a break starts or ends.")
                    .foregroundStyle(.secondary)
            } header: {
                Text("Automations")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Automations")
    }
}
