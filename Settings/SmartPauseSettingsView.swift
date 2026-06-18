import SwiftUI

struct SmartPauseSettingsView: View {
    // Meetings / calls
    @AppStorage(UserSettings.Keys.pauseDuringMeetings) private var pauseDuringMeetings: Bool = UserSettings.Defaults.pauseDuringMeetings
    // Enabled apps
    @AppStorage(UserSettings.Keys.meetingsBundleIds) private var meetingsBundleIds: String = UserSettings.Defaults.meetingsBundleIds
    // Master list (enabled + disabled)
    @AppStorage(UserSettings.Keys.meetingsAppsAll) private var meetingsAppsAll: String = UserSettings.Defaults.meetingsAppsAll

    // Other signals (default off)
    @AppStorage(UserSettings.Keys.pauseDuringScreenRecording) private var pauseDuringScreenRecording: Bool = UserSettings.Defaults.pauseDuringScreenRecording

    @AppStorage(UserSettings.Keys.pauseDuringFullscreenGaming) private var pauseDuringFullscreenGaming: Bool = UserSettings.Defaults.pauseDuringFullscreenGaming
    @AppStorage(UserSettings.Keys.gamingRequiresFullscreen) private var gamingRequiresFullscreen: Bool = UserSettings.Defaults.gamingRequiresFullscreen
    // Enabled list
    @AppStorage(UserSettings.Keys.gamingBundleIds) private var gamingBundleIds: String = UserSettings.Defaults.gamingBundleIds
    // Master list (enabled + disabled)
    @AppStorage(UserSettings.Keys.gamingAppsAll) private var gamingAppsAll: String = UserSettings.Defaults.gamingAppsAll

    @AppStorage(UserSettings.Keys.pauseDuringVideoPlayback) private var pauseDuringVideoPlayback: Bool = UserSettings.Defaults.pauseDuringVideoPlayback
    @AppStorage(UserSettings.Keys.videoRequiresFullscreen) private var videoRequiresFullscreen: Bool = UserSettings.Defaults.videoRequiresFullscreen
    // Enabled list
    @AppStorage(UserSettings.Keys.videoBundleIds) private var videoBundleIds: String = UserSettings.Defaults.videoBundleIds
    // Master list (enabled + disabled)
    @AppStorage(UserSettings.Keys.videoAppsAll) private var videoAppsAll: String = UserSettings.Defaults.videoAppsAll

    // Existing generic frontmost pause list
    @AppStorage(UserSettings.Keys.pauseWhenFrontmostAppMatches) private var pauseWhenFrontmostAppMatches: Bool = UserSettings.Defaults.pauseWhenFrontmostAppMatches
    // Enabled list
    @AppStorage(UserSettings.Keys.pausedBundleIds) private var pausedBundleIds: String = UserSettings.Defaults.pausedBundleIds
    // Master list (enabled + disabled)
    @AppStorage(UserSettings.Keys.pausedAppsAll) private var pausedAppsAll: String = UserSettings.Defaults.pausedAppsAll

    var body: some View {
        Form {
            Section {
                Toggle("Meetings / calls", isOn: $pauseDuringMeetings)
                    .toggleStyle(.switch)
                    .controlSize(.small)

                InstalledAppToggleListEditor(
                    title: "Meeting apps",
                    help: "Pauses breaks when an enabled app is frontmost.",
                    allRawText: $meetingsAppsAll,
                    enabledRawText: $meetingsBundleIds
                )
                .disabled(!pauseDuringMeetings)
            } header: {
                Text("Smart pause")
            } footer: {
                Text("Currently implemented: pauses when an enabled meeting app is frontmost.")
            }

            Section {
                Toggle("Fullscreen gaming", isOn: $pauseDuringFullscreenGaming)
                    .toggleStyle(.switch)
                    .controlSize(.small)

                Toggle("Only when fullscreen", isOn: $gamingRequiresFullscreen)
                    .toggleStyle(.switch)
                    .controlSize(.small)
                    .disabled(!pauseDuringFullscreenGaming)

                InstalledAppToggleListEditor(
                    title: "Gaming apps",
                    help: "Pauses breaks when an enabled gaming app is frontmost.",
                    allRawText: $gamingAppsAll,
                    enabledRawText: $gamingBundleIds
                )
                .disabled(!pauseDuringFullscreenGaming)

                Toggle("Video playback", isOn: $pauseDuringVideoPlayback)
                    .toggleStyle(.switch)
                    .controlSize(.small)

                Toggle("Only when fullscreen", isOn: $videoRequiresFullscreen)
                    .toggleStyle(.switch)
                    .controlSize(.small)
                    .disabled(!pauseDuringVideoPlayback)

                InstalledAppToggleListEditor(
                    title: "Video apps",
                    help: "Pauses breaks when an enabled video app is frontmost.",
                    allRawText: $videoAppsAll,
                    enabledRawText: $videoBundleIds
                )
                .disabled(!pauseDuringVideoPlayback)

                Text("Screen recording detection is coming soon.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } header: {
                Text("More signals")
            }

            Section {
                Toggle("Pause when specific apps are frontmost", isOn: $pauseWhenFrontmostAppMatches)
                    .toggleStyle(.switch)
                    .controlSize(.small)

                InstalledAppToggleListEditor(
                    title: "Additional pause list",
                    help: "Pauses breaks when any enabled app here is frontmost.",
                    allRawText: $pausedAppsAll,
                    enabledRawText: $pausedBundleIds
                )
                .disabled(!pauseWhenFrontmostAppMatches)
            } header: {
                Text("App allow/deny")
            }
        }
        .formStyle(.grouped)
        .navigationTitle("Smart Pause")
    }
}
