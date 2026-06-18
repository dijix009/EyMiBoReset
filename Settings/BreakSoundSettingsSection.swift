import SwiftUI

struct BreakSoundSettingsSection: View {
    @AppStorage(UserSettings.Keys.breakSoundStartEnabled) private var startEnabled: Bool = UserSettings.Defaults.breakSoundStartEnabled
    @AppStorage(UserSettings.Keys.breakSoundEndEnabled) private var endEnabled: Bool = UserSettings.Defaults.breakSoundEndEnabled
    @AppStorage(UserSettings.Keys.breakSoundName) private var soundName: String = UserSettings.Defaults.breakSoundName
    @AppStorage(UserSettings.Keys.breakSoundVolume) private var volume: Double = UserSettings.Defaults.breakSoundVolume

    private let soundOptions: [String] = SoundPlayer.Name.allCases.map { $0.rawValue }

    var body: some View {
        Section {
            Toggle("Sound at break start", isOn: $startEnabled)
            Toggle("Sound at break end", isOn: $endEnabled)

            Picker("Sound", selection: $soundName) {
                ForEach(soundOptions, id: \.self) { name in
                    Text(name).tag(name)
                }
            }
            .pickerStyle(.menu)

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Volume")
                    Spacer()
                    Text(String(format: "%.0f%%", volume * 100))
                        .foregroundStyle(.secondary)
                }
                Slider(value: $volume, in: 0.0...1.0, step: 0.05)
            }

            Button("Test sound") {
                SoundPlayer.shared.play(name: soundName, volume: volume)
            }
        } header: {
            Text("Sounds")
        }
    }
}
