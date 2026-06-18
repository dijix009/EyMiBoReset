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
        static let meetingsBundleIds: String = [
            "us.zoom.xos",
            "com.microsoft.teams",
            "com.microsoft.teams2",
            "com.apple.FaceTime",
            "com.google.Chrome", // for Google Meet (heuristic)
            "com.apple.Safari" // for Google Meet (heuristic)
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

    // MARK: - General

    var statusBarDisplayMode: StatusBarDisplayMode {
        let raw = defaults.string(forKey: Keys.statusBarDisplayMode) ?? Defaults.statusBarDisplayMode
        return StatusBarDisplayMode(rawValue: raw) ?? .text
    }

    var statusBarShowCountdownText: Bool {
        defaults.object(forKey: Keys.statusBarShowCountdownText) as? Bool ?? Defaults.statusBarShowCountdownText
    }

    var reminderPopupPosition: ReminderPopupPosition {
        let raw = defaults.string(forKey: Keys.reminderPopupPosition) ?? Defaults.reminderPopupPosition
        return ReminderPopupPosition(rawValue: raw) ?? .topCenter
    }

    var reminderPopupInteractive: Bool {
        defaults.object(forKey: Keys.reminderPopupInteractive) as? Bool ?? Defaults.reminderPopupInteractive
    }

    var reminderPopupDurationSeconds: Int {
        let v = defaults.integer(forKey: Keys.reminderPopupDurationSeconds)
        return v == 0 ? Defaults.reminderPopupDurationSeconds : v
    }

    var reminderPopupSnoozeMinutes: Int {
        let v = defaults.integer(forKey: Keys.reminderPopupSnoozeMinutes)
        return v == 0 ? Defaults.reminderPopupSnoozeMinutes : v
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
        let raw = defaults.string(forKey: Keys.customReminderPresetsJSON) ?? Defaults.customReminderPresetsJSON
        guard let data = raw.data(using: .utf8) else { return [] }
        return (try? JSONDecoder().decode([ReminderPreset].self, from: data)) ?? []
    }

    func setCustomReminderPresets(_ presets: [ReminderPreset]) {
        let data = (try? JSONEncoder().encode(presets)) ?? Data("[]".utf8)
        let raw = String(data: data, encoding: .utf8) ?? "[]"
        defaults.set(raw, forKey: Keys.customReminderPresetsJSON)
    }

    var intervalMinutes: Int {
        let v = defaults.integer(forKey: Keys.intervalMinutes)
        return v == 0 ? Defaults.intervalMinutes : v
    }

    var breakDuration: Int {
        let v = defaults.integer(forKey: Keys.breakDuration)
        return v == 0 ? Defaults.breakDuration : v
    }

    var pauseDuringMeetings: Bool {
        defaults.object(forKey: Keys.pauseDuringMeetings) as? Bool ?? Defaults.pauseDuringMeetings
    }

    var meetingsBundleIds: String {
        defaults.string(forKey: Keys.meetingsBundleIds) ?? Defaults.meetingsBundleIds
    }

    /// The UI list of meeting apps (enabled + disabled).
    /// If the key wasn't set in older installs, fall back to the enabled list.
    var meetingsAppsAll: String {
        defaults.string(forKey: Keys.meetingsAppsAll) ?? meetingsBundleIds
    }

    var pauseDuringScreenRecording: Bool {
        defaults.object(forKey: Keys.pauseDuringScreenRecording) as? Bool ?? Defaults.pauseDuringScreenRecording
    }

    var pauseDuringFullscreenGaming: Bool {
        defaults.object(forKey: Keys.pauseDuringFullscreenGaming) as? Bool ?? Defaults.pauseDuringFullscreenGaming
    }

    var gamingRequiresFullscreen: Bool {
        defaults.object(forKey: Keys.gamingRequiresFullscreen) as? Bool ?? Defaults.gamingRequiresFullscreen
    }

    var gamingBundleIds: String {
        defaults.string(forKey: Keys.gamingBundleIds) ?? Defaults.gamingBundleIds
    }

    var gamingAppsAll: String {
        defaults.string(forKey: Keys.gamingAppsAll) ?? gamingBundleIds
    }

    var gamingBundleIdentifiers: [String] {
        Self.parseBundleIdList(gamingBundleIds)
    }

    var gamingAppsAllBundleIdentifiers: [String] {
        Self.parseBundleIdList(gamingAppsAll)
    }

    var pauseDuringVideoPlayback: Bool {
        defaults.object(forKey: Keys.pauseDuringVideoPlayback) as? Bool ?? Defaults.pauseDuringVideoPlayback
    }

    var videoRequiresFullscreen: Bool {
        defaults.object(forKey: Keys.videoRequiresFullscreen) as? Bool ?? Defaults.videoRequiresFullscreen
    }

    var videoBundleIds: String {
        defaults.string(forKey: Keys.videoBundleIds) ?? Defaults.videoBundleIds
    }

    var videoAppsAll: String {
        defaults.string(forKey: Keys.videoAppsAll) ?? videoBundleIds
    }

    var videoBundleIdentifiers: [String] {
        Self.parseBundleIdList(videoBundleIds)
    }

    var videoAppsAllBundleIdentifiers: [String] {
        Self.parseBundleIdList(videoAppsAll)
    }

    var pauseWhenFrontmostAppMatches: Bool {
        defaults.object(forKey: Keys.pauseWhenFrontmostAppMatches) as? Bool ?? Defaults.pauseWhenFrontmostAppMatches
    }

    var pausedBundleIds: String {
        defaults.string(forKey: Keys.pausedBundleIds) ?? Defaults.pausedBundleIds
    }

    var pausedAppsAll: String {
        defaults.string(forKey: Keys.pausedAppsAll) ?? pausedBundleIds
    }

    var pausedBundleIdentifiers: [String] {
        Self.parseBundleIdList(pausedBundleIds)
    }

    var pausedAppsAllBundleIdentifiers: [String] {
        Self.parseBundleIdList(pausedAppsAll)
    }

    var meetingsBundleIdentifiers: [String] {
        Self.parseBundleIdList(meetingsBundleIds)
    }

    var meetingsAppsAllBundleIdentifiers: [String] {
        Self.parseBundleIdList(meetingsAppsAll)
    }

    // MARK: - Independent reminders

    var blinkEnabled: Bool {
        defaults.object(forKey: Keys.blinkEnabled) as? Bool ?? Defaults.blinkEnabled
    }

    var blinkIntervalSeconds: Int {
        let v = defaults.integer(forKey: Keys.blinkIntervalSeconds)
        return v == 0 ? Defaults.blinkIntervalSeconds : v
    }

    var postureEnabled: Bool {
        defaults.object(forKey: Keys.postureEnabled) as? Bool ?? Defaults.postureEnabled
    }

    var postureIntervalSeconds: Int {
        let v = defaults.integer(forKey: Keys.postureIntervalSeconds)
        return v == 0 ? Defaults.postureIntervalSeconds : v
    }

    var waterEnabled: Bool {
        defaults.object(forKey: Keys.waterEnabled) as? Bool ?? Defaults.waterEnabled
    }

    var waterIntervalSeconds: Int {
        let v = defaults.integer(forKey: Keys.waterIntervalSeconds)
        return v == 0 ? Defaults.waterIntervalSeconds : v
    }

    var moveEnabled: Bool {
        defaults.object(forKey: Keys.moveEnabled) as? Bool ?? Defaults.moveEnabled
    }

    var moveIntervalSeconds: Int {
        let v = defaults.integer(forKey: Keys.moveIntervalSeconds)
        return v == 0 ? Defaults.moveIntervalSeconds : v
    }

    var stretchEnabled: Bool {
        defaults.object(forKey: Keys.stretchEnabled) as? Bool ?? Defaults.stretchEnabled
    }

    var stretchIntervalSeconds: Int {
        let v = defaults.integer(forKey: Keys.stretchIntervalSeconds)
        return v == 0 ? Defaults.stretchIntervalSeconds : v
    }

    var wristEnabled: Bool {
        defaults.object(forKey: Keys.wristEnabled) as? Bool ?? Defaults.wristEnabled
    }

    var wristIntervalSeconds: Int {
        let v = defaults.integer(forKey: Keys.wristIntervalSeconds)
        return v == 0 ? Defaults.wristIntervalSeconds : v
    }

    var breathingEnabled: Bool {
        defaults.object(forKey: Keys.breathingEnabled) as? Bool ?? Defaults.breathingEnabled
    }

    var breathingIntervalSeconds: Int {
        let v = defaults.integer(forKey: Keys.breathingIntervalSeconds)
        return v == 0 ? Defaults.breathingIntervalSeconds : v
    }

    // MARK: - Menu bar countdown visibility

    var showBlinkCountdownInMenu: Bool {
        defaults.object(forKey: Keys.showBlinkCountdownInMenu) as? Bool ?? Defaults.showBlinkCountdownInMenu
    }

    var showPostureCountdownInMenu: Bool {
        defaults.object(forKey: Keys.showPostureCountdownInMenu) as? Bool ?? Defaults.showPostureCountdownInMenu
    }

    var showWaterCountdownInMenu: Bool {
        defaults.object(forKey: Keys.showWaterCountdownInMenu) as? Bool ?? Defaults.showWaterCountdownInMenu
    }

    var showMoveCountdownInMenu: Bool {
        defaults.object(forKey: Keys.showMoveCountdownInMenu) as? Bool ?? Defaults.showMoveCountdownInMenu
    }

    var showStretchCountdownInMenu: Bool {
        defaults.object(forKey: Keys.showStretchCountdownInMenu) as? Bool ?? Defaults.showStretchCountdownInMenu
    }

    var showWristCountdownInMenu: Bool {
        defaults.object(forKey: Keys.showWristCountdownInMenu) as? Bool ?? Defaults.showWristCountdownInMenu
    }

    var showBreathingCountdownInMenu: Bool {
        defaults.object(forKey: Keys.showBreathingCountdownInMenu) as? Bool ?? Defaults.showBreathingCountdownInMenu
    }

    // MARK: - Break experience

    var preBreakCountdownSeconds: Int {
        let v = defaults.integer(forKey: Keys.preBreakCountdownSeconds)
        return v == 0 ? Defaults.preBreakCountdownSeconds : v
    }

    var snoozeMinutes: Int {
        let v = defaults.integer(forKey: Keys.snoozeMinutes)
        return v == 0 ? Defaults.snoozeMinutes : v
    }

    var allowSkipBreak: Bool {
        defaults.object(forKey: Keys.allowSkipBreak) as? Bool ?? Defaults.allowSkipBreak
    }

    var skipAvailableAfterSeconds: Int {
        // 0 is valid, so check presence.
        guard defaults.object(forKey: Keys.skipAvailableAfterSeconds) != nil else {
            return Defaults.skipAvailableAfterSeconds
        }
        return defaults.integer(forKey: Keys.skipAvailableAfterSeconds)
    }

    var breakMessageTitle: String {
        defaults.string(forKey: Keys.breakMessageTitle) ?? Defaults.breakMessageTitle
    }

    var breakMessageSubtitle: String {
        defaults.string(forKey: Keys.breakMessageSubtitle) ?? Defaults.breakMessageSubtitle
    }

    var breakDimOpacity: Double {
        if let n = defaults.object(forKey: Keys.breakDimOpacity) as? NSNumber {
            return n.doubleValue
        }
        return Defaults.breakDimOpacity
    }

    var breakBlurStyle: Int {
        // 0 is a valid value ("None"), so we must check presence.
        guard defaults.object(forKey: Keys.breakBlurStyle) != nil else {
            return Defaults.breakBlurStyle
        }
        return defaults.integer(forKey: Keys.breakBlurStyle)
    }

    var showBreakOnAllScreens: Bool {
        defaults.object(forKey: Keys.showBreakOnAllScreens) as? Bool ?? Defaults.showBreakOnAllScreens
    }

    var breakSoundStartEnabled: Bool {
        defaults.object(forKey: Keys.breakSoundStartEnabled) as? Bool ?? Defaults.breakSoundStartEnabled
    }

    var breakSoundEndEnabled: Bool {
        defaults.object(forKey: Keys.breakSoundEndEnabled) as? Bool ?? Defaults.breakSoundEndEnabled
    }

    var breakSoundName: String {
        defaults.string(forKey: Keys.breakSoundName) ?? Defaults.breakSoundName
    }

    var breakSoundVolume: Double {
        if let n = defaults.object(forKey: Keys.breakSoundVolume) as? NSNumber {
            return n.doubleValue
        }
        return Defaults.breakSoundVolume
    }

    static func parseBundleIdList(_ raw: String) -> [String] {
        raw
            .replacingOccurrences(of: "\r", with: "\n")
            .split(whereSeparator: { $0 == "\n" || $0 == "," })
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}
