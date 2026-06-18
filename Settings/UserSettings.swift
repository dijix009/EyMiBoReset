import Foundation

final class UserSettings {
    struct ReminderPreset: Codable, Identifiable, Hashable {
        var id: String { name }
        let name: String

        // Enabled flags
        let blinkEnabled: Bool
        let postureEnabled: Bool
        let moveEnabled: Bool
        let stretchEnabled: Bool
        let wristEnabled: Bool
        let breathingEnabled: Bool
        let waterEnabled: Bool

        // Intervals (seconds)
        let blinkIntervalSeconds: Int
        let postureIntervalSeconds: Int
        let moveIntervalSeconds: Int
        let stretchIntervalSeconds: Int
        let wristIntervalSeconds: Int
        let breathingIntervalSeconds: Int
        let waterIntervalSeconds: Int
    }

    enum StatusBarDisplayMode: String {
        case text
        case icon
    }

    enum ReminderPopupPosition: String {
        case topLeft, topCenter, topRight
        case centerLeft, center, centerRight
        case bottomLeft, bottomCenter, bottomRight
    }

    enum Keys {
        /// Convenience list for "Reset to defaults".
        static var all: [String] {
            [
                intervalMinutes,
                breakDuration,

                statusBarDisplayMode,
                statusBarShowCountdownText,
                reminderPopupPosition,
                reminderPopupInteractive,
                reminderPopupDurationSeconds,
                reminderPopupSnoozeMinutes,
                reminderSnoozeUntilEpoch,

                pauseDuringMeetings,
                meetingsBundleIds,
                meetingsAppsAll,
                pauseDuringScreenRecording,
                pauseDuringFullscreenGaming,
                gamingRequiresFullscreen,
                gamingBundleIds,
                gamingAppsAll,
                pauseDuringVideoPlayback,
                videoRequiresFullscreen,
                videoBundleIds,
                videoAppsAll,
                pauseWhenFrontmostAppMatches,
                pausedBundleIds,
                pausedAppsAll,

                blinkEnabled,
                blinkIntervalSeconds,
                postureEnabled,
                postureIntervalSeconds,
                waterEnabled,
                waterIntervalSeconds,
                moveEnabled,
                moveIntervalSeconds,
                stretchEnabled,
                stretchIntervalSeconds,
                wristEnabled,
                wristIntervalSeconds,
                breathingEnabled,
                breathingIntervalSeconds,

                showBlinkCountdownInMenu,
                showPostureCountdownInMenu,
                showWaterCountdownInMenu,
                showMoveCountdownInMenu,
                showStretchCountdownInMenu,
                showWristCountdownInMenu,
                showBreathingCountdownInMenu,

                preBreakCountdownSeconds,
                snoozeMinutes,
                allowSkipBreak,
                skipAvailableAfterSeconds,
                breakMessageTitle,
                breakMessageSubtitle,
                breakDimOpacity,
                breakBlurStyle,
                showBreakOnAllScreens,
                breakSoundStartEnabled,
                breakSoundEndEnabled,
                breakSoundName,
                breakSoundVolume,
            ]
        }
        static let intervalMinutes = "intervalMinutes"
        static let breakDuration = "breakDuration"

        // General
        static let statusBarDisplayMode = "statusBarDisplayMode"
        static let statusBarShowCountdownText = "statusBarShowCountdownText"

        static let reminderPopupPosition = "reminderPopupPosition"
        static let reminderPopupInteractive = "reminderPopupInteractive"
        static let reminderPopupDurationSeconds = "reminderPopupDurationSeconds"
        static let reminderPopupSnoozeMinutes = "reminderPopupSnoozeMinutes"

        // Internal
        static let reminderSnoozeUntilEpoch = "reminderSnoozeUntilEpoch"

        // Smart pause (C)
        static let pauseDuringMeetings = "pauseDuringMeetings"
        /// Enabled meeting apps (used by ActivityMonitor).
        static let meetingsBundleIds = "meetingsBundleIds"
        /// All meeting apps shown in UI (enabled or disabled).
        static let meetingsAppsAll = "meetingsAppsAll"

        static let pauseDuringScreenRecording = "pauseDuringScreenRecording"

        static let pauseDuringFullscreenGaming = "pauseDuringFullscreenGaming"
        static let gamingRequiresFullscreen = "gamingRequiresFullscreen"
        /// Enabled gaming apps (used by ActivityMonitor).
        static let gamingBundleIds = "gamingBundleIds"
        /// All gaming apps shown in UI (enabled or disabled).
        static let gamingAppsAll = "gamingAppsAll"

        static let pauseDuringVideoPlayback = "pauseDuringVideoPlayback"
        static let videoRequiresFullscreen = "videoRequiresFullscreen"
        /// Enabled video apps (used by ActivityMonitor).
        static let videoBundleIds = "videoBundleIds"
        /// All video apps shown in UI (enabled or disabled).
        static let videoAppsAll = "videoAppsAll"

        // Generic frontmost pause list
        static let pauseWhenFrontmostAppMatches = "pauseWhenFrontmostAppMatches"
        /// Enabled apps in the generic pause list.
        static let pausedBundleIds = "pausedBundleIds"
        /// All apps shown in the generic pause list (enabled or disabled).
        static let pausedAppsAll = "pausedAppsAll"

        // Independent reminders
        static let blinkEnabled = "blinkEnabled"
        static let blinkIntervalSeconds = "blinkIntervalSeconds"

        static let postureEnabled = "postureEnabled"
        static let postureIntervalSeconds = "postureIntervalSeconds"

        static let waterEnabled = "waterEnabled"
        static let waterIntervalSeconds = "waterIntervalSeconds"

        static let moveEnabled = "moveEnabled"
        static let moveIntervalSeconds = "moveIntervalSeconds"

        static let stretchEnabled = "stretchEnabled"
        static let stretchIntervalSeconds = "stretchIntervalSeconds"

        static let wristEnabled = "wristEnabled"
        static let wristIntervalSeconds = "wristIntervalSeconds"

        static let breathingEnabled = "breathingEnabled"
        static let breathingIntervalSeconds = "breathingIntervalSeconds"

        // Menu bar countdown visibility
        static let showBlinkCountdownInMenu = "showBlinkCountdownInMenu"
        static let showPostureCountdownInMenu = "showPostureCountdownInMenu"
        static let showWaterCountdownInMenu = "showWaterCountdownInMenu"
        static let showMoveCountdownInMenu = "showMoveCountdownInMenu"
        static let showStretchCountdownInMenu = "showStretchCountdownInMenu"
        static let showWristCountdownInMenu = "showWristCountdownInMenu"
        static let showBreathingCountdownInMenu = "showBreathingCountdownInMenu"

        // Custom reminder presets
        static let customReminderPresetsJSON = "customReminderPresetsJSON"

        // Break experience
        static let preBreakCountdownSeconds = "preBreakCountdownSeconds"
        static let snoozeMinutes = "snoozeMinutes"
        static let allowSkipBreak = "allowSkipBreak"
        static let skipAvailableAfterSeconds = "skipAvailableAfterSeconds"

        static let breakMessageTitle = "breakMessageTitle"
        static let breakMessageSubtitle = "breakMessageSubtitle"
        static let breakDimOpacity = "breakDimOpacity"
        static let breakBlurStyle = "breakBlurStyle"
        static let showBreakOnAllScreens = "showBreakOnAllScreens"

        static let breakSoundStartEnabled = "breakSoundStartEnabled"
        static let breakSoundEndEnabled = "breakSoundEndEnabled"
        static let breakSoundName = "breakSoundName"
        static let breakSoundVolume = "breakSoundVolume"
    }

    enum Defaults {
        static let intervalMinutes: Int = 20
        static let breakDuration: Int = 20

        // General
        static let statusBarDisplayMode: String = StatusBarDisplayMode.text.rawValue
        static let statusBarShowCountdownText: Bool = true

        static let reminderPopupPosition: String = ReminderPopupPosition.topCenter.rawValue
        static let reminderPopupInteractive: Bool = false
        static let reminderPopupDurationSeconds: Int = 3
        static let reminderPopupSnoozeMinutes: Int = 30

        // Default: meetings/calls ON
        static let pauseDuringMeetings: Bool = true
        /// Enabled meeting apps.
        ///
        /// Dedicated video-call apps only. General-purpose browsers (Chrome/Safari) are
        /// intentionally excluded: they are frontmost for most of the working day, so
        /// including them by default would suppress breaks almost permanently. Users who
        /// rely on Google Meet can add their browser explicitly in Smart Pause.
        static let meetingsBundleIds: String = [
            "us.zoom.xos",
            "com.microsoft.teams",
            "com.microsoft.teams2",
            "com.apple.FaceTime"
        ].joined(separator: "\n")
        /// Master list of meeting apps shown in UI.
        /// Default: same as enabled list.
        static let meetingsAppsAll: String = meetingsBundleIds

        // Default: others OFF
        static let pauseDuringScreenRecording: Bool = false

        static let pauseDuringFullscreenGaming: Bool = false
        static let gamingRequiresFullscreen: Bool = true
        static let gamingBundleIds: String = ""
        static let gamingAppsAll: String = gamingBundleIds

        static let pauseDuringVideoPlayback: Bool = false
        static let videoRequiresFullscreen: Bool = true
        static let videoBundleIds: String = ""
        static let videoAppsAll: String = videoBundleIds

        // Generic frontmost list
        static let pauseWhenFrontmostAppMatches: Bool = true
        static let pausedBundleIds: String = ""
        static let pausedAppsAll: String = pausedBundleIds

        // Independent reminders
        // Run during work time, pause during breaks, reset to 0 when break ends.
        static let blinkEnabled: Bool = false
        static let blinkIntervalSeconds: Int = 300  // 5 min

        static let postureEnabled: Bool = false
        static let postureIntervalSeconds: Int = 900 // 15 min

        static let waterEnabled: Bool = false
        static let waterIntervalSeconds: Int = 1800 // 30 min

        static let moveEnabled: Bool = false
        static let moveIntervalSeconds: Int = 3600 // 60 min

        static let stretchEnabled: Bool = false
        static let stretchIntervalSeconds: Int = 5400 // 90 min

        static let wristEnabled: Bool = false
        static let wristIntervalSeconds: Int = 2700 // 45 min

        static let breathingEnabled: Bool = false
        static let breathingIntervalSeconds: Int = 5400 // 90 min

        // Menu bar countdown visibility
        // Default ON only for Blink + Water.
        static let showBlinkCountdownInMenu: Bool = true
        static let showPostureCountdownInMenu: Bool = false
        static let showWaterCountdownInMenu: Bool = true
        static let showMoveCountdownInMenu: Bool = false
        static let showStretchCountdownInMenu: Bool = false
        static let showWristCountdownInMenu: Bool = false
        static let showBreathingCountdownInMenu: Bool = false

        static let customReminderPresetsJSON: String = "[]"

        // Break experience
        static let preBreakCountdownSeconds: Int = 5
        static let snoozeMinutes: Int = 5
        static let allowSkipBreak: Bool = true
        static let skipAvailableAfterSeconds: Int = 5

        static let breakMessageTitle: String = "Look away at least 20 feet / 6 meters"
        static let breakMessageSubtitle: String = ""
        static let breakDimOpacity: Double = 0.35
        static let breakBlurStyle: Int = 1 // 0=none, 1=blur
        static let showBreakOnAllScreens: Bool = true

        static let breakSoundStartEnabled: Bool = false
        static let breakSoundEndEnabled: Bool = false
        static let breakSoundName: String = "Glass"
        static let breakSoundVolume: Double = 0.7
    }

    private let defaults = UserDefaults.standard

    // MARK: - Typed accessors
    //
    // These are presence-aware: a key that was never written returns its default, while a
    // key explicitly set to 0 / "" returns that value. This matters for settings where 0 is
    // a meaningful choice (e.g. `skipAvailableAfterSeconds`, `breakBlurStyle`).

    private func bool(_ key: String, _ fallback: Bool) -> Bool {
        defaults.object(forKey: key) as? Bool ?? fallback
    }

    private func int(_ key: String, _ fallback: Int) -> Int {
        defaults.object(forKey: key) as? Int ?? fallback
    }

    private func double(_ key: String, _ fallback: Double) -> Double {
        (defaults.object(forKey: key) as? NSNumber)?.doubleValue ?? fallback
    }

    private func string(_ key: String, _ fallback: String) -> String {
        defaults.string(forKey: key) ?? fallback
    }

    // MARK: - General

    var statusBarDisplayMode: StatusBarDisplayMode {
        StatusBarDisplayMode(rawValue: string(Keys.statusBarDisplayMode, Defaults.statusBarDisplayMode)) ?? .text
    }

    var statusBarShowCountdownText: Bool {
        bool(Keys.statusBarShowCountdownText, Defaults.statusBarShowCountdownText)
    }

    var reminderPopupPosition: ReminderPopupPosition {
        ReminderPopupPosition(rawValue: string(Keys.reminderPopupPosition, Defaults.reminderPopupPosition)) ?? .topCenter
    }

    var reminderPopupInteractive: Bool {
        bool(Keys.reminderPopupInteractive, Defaults.reminderPopupInteractive)
    }

    var reminderPopupDurationSeconds: Int {
        int(Keys.reminderPopupDurationSeconds, Defaults.reminderPopupDurationSeconds)
    }

    var reminderPopupSnoozeMinutes: Int {
        int(Keys.reminderPopupSnoozeMinutes, Defaults.reminderPopupSnoozeMinutes)
    }

    // Stored as epoch seconds to avoid Date encoding.
    var reminderSnoozeUntil: Date? {
        guard defaults.object(forKey: Keys.reminderSnoozeUntilEpoch) != nil else { return nil }
        let t = defaults.double(forKey: Keys.reminderSnoozeUntilEpoch)
        guard t > 0 else { return nil }
        return Date(timeIntervalSince1970: t)
    }

    func setReminderSnoozeUntil(_ date: Date?) {
        if let date {
            defaults.set(date.timeIntervalSince1970, forKey: Keys.reminderSnoozeUntilEpoch)
        } else {
            defaults.removeObject(forKey: Keys.reminderSnoozeUntilEpoch)
        }
    }

    func resetToDefaults() {
        Keys.all.forEach { defaults.removeObject(forKey: $0) }
    }

    // MARK: - Custom reminder presets

    func getCustomReminderPresets() -> [ReminderPreset] {
        let raw = string(Keys.customReminderPresetsJSON, Defaults.customReminderPresetsJSON)
        guard let data = raw.data(using: .utf8) else { return [] }
        return (try? JSONDecoder().decode([ReminderPreset].self, from: data)) ?? []
    }

    func setCustomReminderPresets(_ presets: [ReminderPreset]) {
        let data = (try? JSONEncoder().encode(presets)) ?? Data("[]".utf8)
        let raw = String(data: data, encoding: .utf8) ?? "[]"
        defaults.set(raw, forKey: Keys.customReminderPresetsJSON)
    }

    var intervalMinutes: Int {
        int(Keys.intervalMinutes, Defaults.intervalMinutes)
    }

    var breakDuration: Int {
        int(Keys.breakDuration, Defaults.breakDuration)
    }

    // MARK: - Smart pause

    var pauseDuringMeetings: Bool {
        bool(Keys.pauseDuringMeetings, Defaults.pauseDuringMeetings)
    }

    var meetingsBundleIds: String {
        string(Keys.meetingsBundleIds, Defaults.meetingsBundleIds)
    }

    /// The UI list of meeting apps (enabled + disabled).
    /// If the key wasn't set in older installs, fall back to the enabled list.
    var meetingsAppsAll: String {
        defaults.string(forKey: Keys.meetingsAppsAll) ?? meetingsBundleIds
    }

    var pauseDuringScreenRecording: Bool {
        bool(Keys.pauseDuringScreenRecording, Defaults.pauseDuringScreenRecording)
    }

    var pauseDuringFullscreenGaming: Bool {
        bool(Keys.pauseDuringFullscreenGaming, Defaults.pauseDuringFullscreenGaming)
    }

    var gamingRequiresFullscreen: Bool {
        bool(Keys.gamingRequiresFullscreen, Defaults.gamingRequiresFullscreen)
    }

    var gamingBundleIds: String {
        string(Keys.gamingBundleIds, Defaults.gamingBundleIds)
    }

    var gamingAppsAll: String {
        defaults.string(forKey: Keys.gamingAppsAll) ?? gamingBundleIds
    }

    var pauseDuringVideoPlayback: Bool {
        bool(Keys.pauseDuringVideoPlayback, Defaults.pauseDuringVideoPlayback)
    }

    var videoRequiresFullscreen: Bool {
        bool(Keys.videoRequiresFullscreen, Defaults.videoRequiresFullscreen)
    }

    var videoBundleIds: String {
        string(Keys.videoBundleIds, Defaults.videoBundleIds)
    }

    var videoAppsAll: String {
        defaults.string(forKey: Keys.videoAppsAll) ?? videoBundleIds
    }

    var pauseWhenFrontmostAppMatches: Bool {
        bool(Keys.pauseWhenFrontmostAppMatches, Defaults.pauseWhenFrontmostAppMatches)
    }

    var pausedBundleIds: String {
        string(Keys.pausedBundleIds, Defaults.pausedBundleIds)
    }

    var pausedAppsAll: String {
        defaults.string(forKey: Keys.pausedAppsAll) ?? pausedBundleIds
    }

    // MARK: - Smart pause: parsed bundle-id lists

    var meetingsBundleIdentifiers: [String] { Self.parseBundleIdList(meetingsBundleIds) }
    var meetingsAppsAllBundleIdentifiers: [String] { Self.parseBundleIdList(meetingsAppsAll) }

    var gamingBundleIdentifiers: [String] { Self.parseBundleIdList(gamingBundleIds) }
    var gamingAppsAllBundleIdentifiers: [String] { Self.parseBundleIdList(gamingAppsAll) }

    var videoBundleIdentifiers: [String] { Self.parseBundleIdList(videoBundleIds) }
    var videoAppsAllBundleIdentifiers: [String] { Self.parseBundleIdList(videoAppsAll) }

    var pausedBundleIdentifiers: [String] { Self.parseBundleIdList(pausedBundleIds) }
    var pausedAppsAllBundleIdentifiers: [String] { Self.parseBundleIdList(pausedAppsAll) }

    // MARK: - Independent reminders

    var blinkEnabled: Bool { bool(Keys.blinkEnabled, Defaults.blinkEnabled) }
    var blinkIntervalSeconds: Int { int(Keys.blinkIntervalSeconds, Defaults.blinkIntervalSeconds) }

    var postureEnabled: Bool { bool(Keys.postureEnabled, Defaults.postureEnabled) }
    var postureIntervalSeconds: Int { int(Keys.postureIntervalSeconds, Defaults.postureIntervalSeconds) }

    var waterEnabled: Bool { bool(Keys.waterEnabled, Defaults.waterEnabled) }
    var waterIntervalSeconds: Int { int(Keys.waterIntervalSeconds, Defaults.waterIntervalSeconds) }

    var moveEnabled: Bool { bool(Keys.moveEnabled, Defaults.moveEnabled) }
    var moveIntervalSeconds: Int { int(Keys.moveIntervalSeconds, Defaults.moveIntervalSeconds) }

    var stretchEnabled: Bool { bool(Keys.stretchEnabled, Defaults.stretchEnabled) }
    var stretchIntervalSeconds: Int { int(Keys.stretchIntervalSeconds, Defaults.stretchIntervalSeconds) }

    var wristEnabled: Bool { bool(Keys.wristEnabled, Defaults.wristEnabled) }
    var wristIntervalSeconds: Int { int(Keys.wristIntervalSeconds, Defaults.wristIntervalSeconds) }

    var breathingEnabled: Bool { bool(Keys.breathingEnabled, Defaults.breathingEnabled) }
    var breathingIntervalSeconds: Int { int(Keys.breathingIntervalSeconds, Defaults.breathingIntervalSeconds) }

    // MARK: - Menu bar countdown visibility

    var showBlinkCountdownInMenu: Bool { bool(Keys.showBlinkCountdownInMenu, Defaults.showBlinkCountdownInMenu) }
    var showPostureCountdownInMenu: Bool { bool(Keys.showPostureCountdownInMenu, Defaults.showPostureCountdownInMenu) }
    var showWaterCountdownInMenu: Bool { bool(Keys.showWaterCountdownInMenu, Defaults.showWaterCountdownInMenu) }
    var showMoveCountdownInMenu: Bool { bool(Keys.showMoveCountdownInMenu, Defaults.showMoveCountdownInMenu) }
    var showStretchCountdownInMenu: Bool { bool(Keys.showStretchCountdownInMenu, Defaults.showStretchCountdownInMenu) }
    var showWristCountdownInMenu: Bool { bool(Keys.showWristCountdownInMenu, Defaults.showWristCountdownInMenu) }
    var showBreathingCountdownInMenu: Bool { bool(Keys.showBreathingCountdownInMenu, Defaults.showBreathingCountdownInMenu) }

    // MARK: - Break experience

    var preBreakCountdownSeconds: Int { int(Keys.preBreakCountdownSeconds, Defaults.preBreakCountdownSeconds) }
    var snoozeMinutes: Int { int(Keys.snoozeMinutes, Defaults.snoozeMinutes) }
    var allowSkipBreak: Bool { bool(Keys.allowSkipBreak, Defaults.allowSkipBreak) }
    var skipAvailableAfterSeconds: Int { int(Keys.skipAvailableAfterSeconds, Defaults.skipAvailableAfterSeconds) }

    var breakMessageTitle: String { string(Keys.breakMessageTitle, Defaults.breakMessageTitle) }
    var breakMessageSubtitle: String { string(Keys.breakMessageSubtitle, Defaults.breakMessageSubtitle) }
    var breakDimOpacity: Double { double(Keys.breakDimOpacity, Defaults.breakDimOpacity) }
    var breakBlurStyle: Int { int(Keys.breakBlurStyle, Defaults.breakBlurStyle) }
    var showBreakOnAllScreens: Bool { bool(Keys.showBreakOnAllScreens, Defaults.showBreakOnAllScreens) }

    var breakSoundStartEnabled: Bool { bool(Keys.breakSoundStartEnabled, Defaults.breakSoundStartEnabled) }
    var breakSoundEndEnabled: Bool { bool(Keys.breakSoundEndEnabled, Defaults.breakSoundEndEnabled) }
    var breakSoundName: String { string(Keys.breakSoundName, Defaults.breakSoundName) }
    var breakSoundVolume: Double { double(Keys.breakSoundVolume, Defaults.breakSoundVolume) }

    // MARK: - Parsing

    static func parseBundleIdList(_ raw: String) -> [String] {
        raw
            .replacingOccurrences(of: "\r", with: "\n")
            .split(whereSeparator: { $0 == "\n" || $0 == "," })
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}
