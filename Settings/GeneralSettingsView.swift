import SwiftUI

struct GeneralSettingsView: View {
    @State private var showResetConfirm = false
    private let settings = UserSettings()
    // Status bar
    @AppStorage(UserSettings.Keys.statusBarDisplayMode) private var statusBarDisplayMode: String = UserSettings.Defaults.statusBarDisplayMode
    @AppStorage(UserSettings.Keys.statusBarShowCountdownText) private var statusBarShowCountdownText: Bool = UserSettings.Defaults.statusBarShowCountdownText

    // Reminder popup
    @AppStorage(UserSettings.Keys.reminderPopupPosition) private var reminderPopupPosition: String = UserSettings.Defaults.reminderPopupPosition
    @AppStorage(UserSettings.Keys.reminderPopupInteractive) private var reminderPopupInteractive: Bool = UserSettings.Defaults.reminderPopupInteractive
    @AppStorage(UserSettings.Keys.reminderPopupDurationSeconds) private var reminderPopupDurationSeconds: Int = UserSettings.Defaults.reminderPopupDurationSeconds
    @AppStorage(UserSettings.Keys.reminderPopupSnoozeMinutes) private var reminderPopupSnoozeMinutes: Int = UserSettings.Defaults.reminderPopupSnoozeMinutes

    private let durationOptions = [1, 2, 3, 4, 5]
    private let snoozeOptions = [5, 10, 15, 30, 60]

    var body: some View {
        Form {
            Section {
                Picker("Status bar", selection: $statusBarDisplayMode) {
                    Text("Text (EMB)").tag(UserSettings.StatusBarDisplayMode.text.rawValue)
                    Text("Icon").tag(UserSettings.StatusBarDisplayMode.icon.rawValue)
                }
                .pickerStyle(.menu)

                Toggle("Show countdown text", isOn: $statusBarShowCountdownText)
                    .toggleStyle(.switch)
            } header: {
                Text("Menu bar")
            } footer: {
                Text("Choose whether EyMiBo Reset shows as text or a small icon in the menu bar.")
            }

            Section {
                if let until = settings.reminderSnoozeUntil, until > Date() {
                    Text("Reminders snoozed until \(until.formatted(date: .omitted, time: .shortened))")
                        .foregroundStyle(.secondary)

                    Button("Resume reminders now") {
                        settings.setReminderSnoozeUntil(nil)
                    }
                }

                Picker("Position", selection: $reminderPopupPosition) {
                    Text("Top center").tag(UserSettings.ReminderPopupPosition.topCenter.rawValue)
                    Text("Top left").tag(UserSettings.ReminderPopupPosition.topLeft.rawValue)
                    Text("Top right").tag(UserSettings.ReminderPopupPosition.topRight.rawValue)

                    Text("Center").tag(UserSettings.ReminderPopupPosition.center.rawValue)
                    Text("Center left").tag(UserSettings.ReminderPopupPosition.centerLeft.rawValue)
                    Text("Center right").tag(UserSettings.ReminderPopupPosition.centerRight.rawValue)

                    Text("Bottom center").tag(UserSettings.ReminderPopupPosition.bottomCenter.rawValue)
                    Text("Bottom left").tag(UserSettings.ReminderPopupPosition.bottomLeft.rawValue)
                    Text("Bottom right").tag(UserSettings.ReminderPopupPosition.bottomRight.rawValue)
                }
                .pickerStyle(.menu)

                Picker("Duration", selection: $reminderPopupDurationSeconds) {
                    ForEach(durationOptions, id: \.self) { s in
                        Text("\(s)s").tag(s)
                    }
                }
                .pickerStyle(.menu)

                Toggle("Interactive popup (snooze)", isOn: $reminderPopupInteractive)
                    .toggleStyle(.switch)

                Picker("Snooze length", selection: $reminderPopupSnoozeMinutes) {
                    ForEach(snoozeOptions, id: \.self) { m in
                        Text("\(m) min").tag(m)
                    }
                }
                .pickerStyle(.menu)
                .disabled(!reminderPopupInteractive)
            } header: {
                Text("Reminder popup")
            } footer: {
                Text("Default: top-center, subtle animation, 3 seconds, passive.")
            }

            Section {
                Button(role: .destructive) {
                    showResetConfirm = true
                } label: {
                    Text("Reset all settings to defaults…")
                }
            } header: {
                Text("Maintenance")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("General")
        .alert("Reset all settings?", isPresented: $showResetConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) {
                settings.resetToDefaults()
            }
        } message: {
            Text("This will reset all EyMiBo Reset settings back to their defaults.")
        }
    }
}
