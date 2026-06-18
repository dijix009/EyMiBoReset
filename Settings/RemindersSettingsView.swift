import SwiftUI

struct RemindersSettingsView: View {
    @State private var showSavePresetPrompt = false
    @State private var newPresetName: String = ""
    @State private var customPresets: [UserSettings.ReminderPreset] = []

    private let settings = UserSettings()
    // Eyes
    @AppStorage(UserSettings.Keys.blinkEnabled) private var blinkEnabled: Bool = UserSettings.Defaults.blinkEnabled
    @AppStorage(UserSettings.Keys.blinkIntervalSeconds) private var blinkIntervalSeconds: Int = UserSettings.Defaults.blinkIntervalSeconds
    @AppStorage(UserSettings.Keys.showBlinkCountdownInMenu) private var showBlinkCountdownInMenu: Bool = UserSettings.Defaults.showBlinkCountdownInMenu

    // Body
    @AppStorage(UserSettings.Keys.postureEnabled) private var postureEnabled: Bool = UserSettings.Defaults.postureEnabled
    @AppStorage(UserSettings.Keys.postureIntervalSeconds) private var postureIntervalSeconds: Int = UserSettings.Defaults.postureIntervalSeconds
    @AppStorage(UserSettings.Keys.showPostureCountdownInMenu) private var showPostureCountdownInMenu: Bool = UserSettings.Defaults.showPostureCountdownInMenu

    @AppStorage(UserSettings.Keys.moveEnabled) private var moveEnabled: Bool = UserSettings.Defaults.moveEnabled
    @AppStorage(UserSettings.Keys.moveIntervalSeconds) private var moveIntervalSeconds: Int = UserSettings.Defaults.moveIntervalSeconds
    @AppStorage(UserSettings.Keys.showMoveCountdownInMenu) private var showMoveCountdownInMenu: Bool = UserSettings.Defaults.showMoveCountdownInMenu

    @AppStorage(UserSettings.Keys.stretchEnabled) private var stretchEnabled: Bool = UserSettings.Defaults.stretchEnabled
    @AppStorage(UserSettings.Keys.stretchIntervalSeconds) private var stretchIntervalSeconds: Int = UserSettings.Defaults.stretchIntervalSeconds
    @AppStorage(UserSettings.Keys.showStretchCountdownInMenu) private var showStretchCountdownInMenu: Bool = UserSettings.Defaults.showStretchCountdownInMenu

    @AppStorage(UserSettings.Keys.wristEnabled) private var wristEnabled: Bool = UserSettings.Defaults.wristEnabled
    @AppStorage(UserSettings.Keys.wristIntervalSeconds) private var wristIntervalSeconds: Int = UserSettings.Defaults.wristIntervalSeconds
    @AppStorage(UserSettings.Keys.showWristCountdownInMenu) private var showWristCountdownInMenu: Bool = UserSettings.Defaults.showWristCountdownInMenu

    // Mind
    @AppStorage(UserSettings.Keys.breathingEnabled) private var breathingEnabled: Bool = UserSettings.Defaults.breathingEnabled
    @AppStorage(UserSettings.Keys.breathingIntervalSeconds) private var breathingIntervalSeconds: Int = UserSettings.Defaults.breathingIntervalSeconds
    @AppStorage(UserSettings.Keys.showBreathingCountdownInMenu) private var showBreathingCountdownInMenu: Bool = UserSettings.Defaults.showBreathingCountdownInMenu

    // Hydration
    @AppStorage(UserSettings.Keys.waterEnabled) private var waterEnabled: Bool = UserSettings.Defaults.waterEnabled
    @AppStorage(UserSettings.Keys.waterIntervalSeconds) private var waterIntervalSeconds: Int = UserSettings.Defaults.waterIntervalSeconds
    @AppStorage(UserSettings.Keys.showWaterCountdownInMenu) private var showWaterCountdownInMenu: Bool = UserSettings.Defaults.showWaterCountdownInMenu

    private let blinkMinutes: [Int] = [1, 2, 3, 5, 10, 15]
    private let postureMinutes: [Int] = [5, 10, 15, 20, 30]
    private let moveMinutes: [Int] = [30, 45, 60, 90]
    private let stretchMinutes: [Int] = [45, 60, 90, 120]
    private let wristMinutes: [Int] = [20, 30, 45, 60]
    private let breathingMinutes: [Int] = [45, 60, 90, 120]
    private let waterMinutes: [Int] = [10, 15, 30, 45, 60]

    var body: some View {
        Form {
            Section {
                Button("Office health preset") {
                    applyPreset(.init(
                        name: "Office health",
                        blinkEnabled: blinkEnabled,
                        postureEnabled: true,
                        moveEnabled: true,
                        stretchEnabled: true,
                        wristEnabled: true,
                        breathingEnabled: true,
                        waterEnabled: waterEnabled,
                        blinkIntervalSeconds: blinkIntervalSeconds,
                        postureIntervalSeconds: 15 * 60,
                        moveIntervalSeconds: 60 * 60,
                        stretchIntervalSeconds: 90 * 60,
                        wristIntervalSeconds: 45 * 60,
                        breathingIntervalSeconds: 90 * 60,
                        waterIntervalSeconds: waterIntervalSeconds
                    ))
                }

                Button("Disable all reminders") {
                    blinkEnabled = false
                    postureEnabled = false
                    moveEnabled = false
                    stretchEnabled = false
                    wristEnabled = false
                    breathingEnabled = false
                    waterEnabled = false

                    notifyChanged()
                }

                if !customPresets.isEmpty {
                    ForEach(customPresets, id: \.name) { preset in
                        HStack {
                            Button(preset.name) {
                                applyPreset(preset)
                            }
                            Spacer()
                            Button(role: .destructive) {
                                deletePreset(named: preset.name)
                            } label: {
                                Text("Delete")
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }

                // Always keep this as the last row.
                Button("Save current as preset…") {
                    newPresetName = ""
                    showSavePresetPrompt = true
                }
            } header: {
                Text("Presets")
            }

            Section {
                Toggle("Blink", isOn: $blinkEnabled)

                SettingsPopUpRow(
                    title: "Blink interval",
                    help: "Runs during work time. Pauses during breaks and resets after a break.",
                    values: blinkMinutes,
                    defaultValue: max(1, UserSettings.Defaults.blinkIntervalSeconds / 60),
                    unit: "min",
                    selection: Binding(
                        get: { max(1, blinkIntervalSeconds / 60) },
                        set: { blinkIntervalSeconds = max(60, $0 * 60) }
                    )
                )
                .disabled(!blinkEnabled)

                Toggle("Show countdown in menu bar", isOn: $showBlinkCountdownInMenu)
                    .toggleStyle(.switch)
                    .disabled(!blinkEnabled)
            } header: {
                Text("Eyes")
            }

            Section {
                Toggle("Breathing reset", isOn: $breathingEnabled)

                SettingsPopUpRow(
                    title: "Breathing interval",
                    help: "Runs during work time. Pauses during breaks and resets after a break.",
                    values: breathingMinutes,
                    defaultValue: max(1, UserSettings.Defaults.breathingIntervalSeconds / 60),
                    unit: "min",
                    selection: Binding(
                        get: { max(1, breathingIntervalSeconds / 60) },
                        set: { breathingIntervalSeconds = max(60, $0 * 60) }
                    )
                )
                .disabled(!breathingEnabled)

                Toggle("Show countdown in menu bar", isOn: $showBreathingCountdownInMenu)
                    .toggleStyle(.switch)
                    .disabled(!breathingEnabled)
            } header: {
                Text("Mind")
            }

            Section {
                // Wrap all Body reminder cards into a single row to avoid Form row separators between them.
                VStack(alignment: .leading, spacing: 12) {
                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            Toggle("Straight back", isOn: $postureEnabled)

                            SettingsPopUpRow(
                                title: "Interval",
                                help: "Runs during work time. Pauses during breaks and resets after a break.",
                                values: postureMinutes,
                                defaultValue: max(1, UserSettings.Defaults.postureIntervalSeconds / 60),
                                unit: "min",
                                selection: Binding(
                                    get: { max(1, postureIntervalSeconds / 60) },
                                    set: { postureIntervalSeconds = max(60, $0 * 60) }
                                )
                            )
                            .disabled(!postureEnabled)

                            Toggle("Show countdown in menu bar", isOn: $showPostureCountdownInMenu)
                                .toggleStyle(.switch)
                                .disabled(!postureEnabled)
                        }
                        .padding(8)
                    }

                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            Toggle("Move / stand", isOn: $moveEnabled)

                            SettingsPopUpRow(
                                title: "Interval",
                                help: "Runs during work time. Pauses during breaks and resets after a break.",
                                values: moveMinutes,
                                defaultValue: max(1, UserSettings.Defaults.moveIntervalSeconds / 60),
                                unit: "min",
                                selection: Binding(
                                    get: { max(1, moveIntervalSeconds / 60) },
                                    set: { moveIntervalSeconds = max(60, $0 * 60) }
                                )
                            )
                            .disabled(!moveEnabled)

                            Toggle("Show countdown in menu bar", isOn: $showMoveCountdownInMenu)
                                .toggleStyle(.switch)
                                .disabled(!moveEnabled)
                        }
                        .padding(8)
                    }

                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            Toggle("Stretch", isOn: $stretchEnabled)

                            SettingsPopUpRow(
                                title: "Interval",
                                help: "Runs during work time. Pauses during breaks and resets after a break.",
                                values: stretchMinutes,
                                defaultValue: max(1, UserSettings.Defaults.stretchIntervalSeconds / 60),
                                unit: "min",
                                selection: Binding(
                                    get: { max(1, stretchIntervalSeconds / 60) },
                                    set: { stretchIntervalSeconds = max(60, $0 * 60) }
                                )
                            )
                            .disabled(!stretchEnabled)

                            Toggle("Show countdown in menu bar", isOn: $showStretchCountdownInMenu)
                                .toggleStyle(.switch)
                                .disabled(!stretchEnabled)
                        }
                        .padding(8)
                    }

                    GroupBox {
                        VStack(alignment: .leading, spacing: 10) {
                            Toggle("Wrist break", isOn: $wristEnabled)

                            SettingsPopUpRow(
                                title: "Interval",
                                help: "Runs during work time. Pauses during breaks and resets after a break.",
                                values: wristMinutes,
                                defaultValue: max(1, UserSettings.Defaults.wristIntervalSeconds / 60),
                                unit: "min",
                                selection: Binding(
                                    get: { max(1, wristIntervalSeconds / 60) },
                                    set: { wristIntervalSeconds = max(60, $0 * 60) }
                                )
                            )
                            .disabled(!wristEnabled)

                            Toggle("Show countdown in menu bar", isOn: $showWristCountdownInMenu)
                                .toggleStyle(.switch)
                                .disabled(!wristEnabled)
                        }
                        .padding(8)
                    }
                }
            } header: {
                Text("Body")
            }

            Section {
                Toggle("Drink water", isOn: $waterEnabled)

                SettingsPopUpRow(
                    title: "Drink water interval",
                    help: "Runs during work time. Pauses during breaks and resets after a break.",
                    values: waterMinutes,
                    defaultValue: max(1, UserSettings.Defaults.waterIntervalSeconds / 60),
                    unit: "min",
                    selection: Binding(
                        get: { max(1, waterIntervalSeconds / 60) },
                        set: { waterIntervalSeconds = max(60, $0 * 60) }
                    )
                )
                .disabled(!waterEnabled)

                Toggle("Show countdown in menu bar", isOn: $showWaterCountdownInMenu)
                    .toggleStyle(.switch)
                    .disabled(!waterEnabled)
            } header: {
                Text("Hydration")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Reminders")
        .onAppear {
            customPresets = settings.getCustomReminderPresets()
        }
        .onChange(of: blinkEnabled) { _ in notifyChanged() }
        .alert("Save preset", isPresented: $showSavePresetPrompt) {
            TextField("Preset name", text: $newPresetName)
            Button("Cancel", role: .cancel) {}
            Button("Save") {
                savePreset(named: newPresetName)
            }
        } message: {
            Text("Save your current reminder configuration as a reusable preset.")
        }
        .onChange(of: blinkIntervalSeconds) { _ in notifyChanged() }
        .onChange(of: postureEnabled) { _ in notifyChanged() }
        .onChange(of: postureIntervalSeconds) { _ in notifyChanged() }
        .onChange(of: waterEnabled) { _ in notifyChanged() }
        .onChange(of: waterIntervalSeconds) { _ in notifyChanged() }
        .onChange(of: moveEnabled) { _ in notifyChanged() }
        .onChange(of: moveIntervalSeconds) { _ in notifyChanged() }
        .onChange(of: stretchEnabled) { _ in notifyChanged() }
        .onChange(of: stretchIntervalSeconds) { _ in notifyChanged() }
        .onChange(of: wristEnabled) { _ in notifyChanged() }
        .onChange(of: wristIntervalSeconds) { _ in notifyChanged() }
        .onChange(of: breathingEnabled) { _ in notifyChanged() }
        .onChange(of: breathingIntervalSeconds) { _ in notifyChanged() }
    }

    private func notifyChanged() {
        NotificationCenter.default.post(name: ReminderNotifications.settingsChanged, object: nil)
    }

    // MARK: - Presets

    private func currentPreset(named name: String) -> UserSettings.ReminderPreset {
        .init(
            name: name,
            blinkEnabled: blinkEnabled,
            postureEnabled: postureEnabled,
            moveEnabled: moveEnabled,
            stretchEnabled: stretchEnabled,
            wristEnabled: wristEnabled,
            breathingEnabled: breathingEnabled,
            waterEnabled: waterEnabled,
            blinkIntervalSeconds: blinkIntervalSeconds,
            postureIntervalSeconds: postureIntervalSeconds,
            moveIntervalSeconds: moveIntervalSeconds,
            stretchIntervalSeconds: stretchIntervalSeconds,
            wristIntervalSeconds: wristIntervalSeconds,
            breathingIntervalSeconds: breathingIntervalSeconds,
            waterIntervalSeconds: waterIntervalSeconds
        )
    }

    private func applyPreset(_ preset: UserSettings.ReminderPreset) {
        blinkEnabled = preset.blinkEnabled
        postureEnabled = preset.postureEnabled
        moveEnabled = preset.moveEnabled
        stretchEnabled = preset.stretchEnabled
        wristEnabled = preset.wristEnabled
        breathingEnabled = preset.breathingEnabled
        waterEnabled = preset.waterEnabled

        blinkIntervalSeconds = preset.blinkIntervalSeconds
        postureIntervalSeconds = preset.postureIntervalSeconds
        moveIntervalSeconds = preset.moveIntervalSeconds
        stretchIntervalSeconds = preset.stretchIntervalSeconds
        wristIntervalSeconds = preset.wristIntervalSeconds
        breathingIntervalSeconds = preset.breathingIntervalSeconds
        waterIntervalSeconds = preset.waterIntervalSeconds

        notifyChanged()
    }

    private func savePreset(named rawName: String) {
        let name = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !name.isEmpty else { return }

        var presets = settings.getCustomReminderPresets()
        // Replace if same name exists.
        presets.removeAll { $0.name.caseInsensitiveCompare(name) == .orderedSame }
        presets.append(currentPreset(named: name))
        presets.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        settings.setCustomReminderPresets(presets)
        customPresets = presets
    }

    private func deletePreset(named name: String) {
        var presets = settings.getCustomReminderPresets()
        presets.removeAll { $0.name == name }
        settings.setCustomReminderPresets(presets)
        customPresets = presets
    }
}
