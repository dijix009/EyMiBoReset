import SwiftUI

struct BreakExperienceSettingsView: View {
    @AppStorage(UserSettings.Keys.intervalMinutes) private var intervalMinutes: Int = UserSettings.Defaults.intervalMinutes
    @AppStorage(UserSettings.Keys.breakDuration) private var breakDuration: Int = UserSettings.Defaults.breakDuration

    @AppStorage(UserSettings.Keys.preBreakCountdownSeconds) private var preBreakCountdownSeconds: Int = UserSettings.Defaults.preBreakCountdownSeconds
    @AppStorage(UserSettings.Keys.snoozeMinutes) private var snoozeMinutes: Int = UserSettings.Defaults.snoozeMinutes
    @AppStorage(UserSettings.Keys.allowSkipBreak) private var allowSkipBreak: Bool = UserSettings.Defaults.allowSkipBreak
    @AppStorage(UserSettings.Keys.skipAvailableAfterSeconds) private var skipAvailableAfterSeconds: Int = UserSettings.Defaults.skipAvailableAfterSeconds

    @AppStorage(UserSettings.Keys.breakMessageTitle) private var breakMessageTitle: String = UserSettings.Defaults.breakMessageTitle
    @AppStorage(UserSettings.Keys.breakMessageSubtitle) private var breakMessageSubtitle: String = UserSettings.Defaults.breakMessageSubtitle
    @AppStorage(UserSettings.Keys.breakDimOpacity) private var breakDimOpacity: Double = UserSettings.Defaults.breakDimOpacity
    @AppStorage(UserSettings.Keys.breakBlurStyle) private var breakBlurStyle: Int = UserSettings.Defaults.breakBlurStyle
    @AppStorage(UserSettings.Keys.showBreakOnAllScreens) private var showBreakOnAllScreens: Bool = UserSettings.Defaults.showBreakOnAllScreens

    private let countdownOptions: [Int] = [3, 5, 8, 10, 15]
    private let snoozeOptions: [Int] = [1, 3, 5, 10, 15]
    private let skipAfterOptions: [Int] = [0, 3, 5, 10, 15]

    var body: some View {
        Form {
            Section {
                SettingsPopUpRow(
                    title: "Break interval",
                    help: nil,
                    values: TimerPresets.intervalMinutes,
                    defaultValue: UserSettings.Defaults.intervalMinutes,
                    unit: "min",
                    selection: $intervalMinutes
                )

                SettingsPopUpRow(
                    title: "Break duration",
                    help: nil,
                    values: TimerPresets.breakDurationSeconds,
                    defaultValue: UserSettings.Defaults.breakDuration,
                    unit: "sec",
                    selection: $breakDuration
                )

                // Fine-tune (optional)
                DisclosureGroup("Fine tune") {
                    Stepper("Interval: \(intervalMinutes) min", value: $intervalMinutes, in: 1...180, step: 1)
                    Stepper("Duration: \(breakDuration) sec", value: $breakDuration, in: 5...180, step: 1)
                }
            } header: {
                Text("Timers")
            } footer: {
                Text("Default: 20 minutes work, then a 20 second break (20–20–20 rule).")
            }

            Section {
                SettingsPopUpRow(
                    title: "Pre-break countdown",
                    help: "How long the upcoming-break notification counts down before the break starts automatically.",
                    values: countdownOptions,
                    defaultValue: UserSettings.Defaults.preBreakCountdownSeconds,
                    unit: "sec",
                    selection: $preBreakCountdownSeconds
                )

                SettingsPopUpRow(
                    title: "Snooze duration",
                    help: "If you snooze an upcoming break, wait this long before trying again.",
                    values: snoozeOptions,
                    defaultValue: UserSettings.Defaults.snoozeMinutes,
                    unit: "min",
                    selection: $snoozeMinutes
                )

                Toggle("Show break on all screens", isOn: $showBreakOnAllScreens)
            } header: {
                Text("Scheduling")
            }

            Section {
                TextField("Title", text: $breakMessageTitle)
                TextField("Subtitle (optional)", text: $breakMessageSubtitle)

                Picker("Background", selection: $breakBlurStyle) {
                    Text("Blur").tag(1)
                    Text("None").tag(0)
                }
                .pickerStyle(.menu)

                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Dim strength")
                        Spacer()
                        Text(String(format: "%.0f%%", breakDimOpacity * 100))
                            .foregroundStyle(.secondary)
                    }
                    Slider(value: $breakDimOpacity, in: 0.0...0.8, step: 0.05)
                }
            } header: {
                Text("Break screen")
            }

            Section {
                Toggle("Allow skipping breaks", isOn: $allowSkipBreak)

                SettingsPopUpRow(
                    title: "Skip available after",
                    help: "If enabled, you can enforce a short minimum break before Skip becomes available.",
                    values: skipAfterOptions,
                    defaultValue: UserSettings.Defaults.skipAvailableAfterSeconds,
                    unit: "sec",
                    selection: $skipAvailableAfterSeconds
                )
                .disabled(!allowSkipBreak)
            } header: {
                Text("Skipping")
            }

            BreakSoundSettingsSection()
        }
        .formStyle(.grouped)
        .navigationTitle("Break")
    }
}
