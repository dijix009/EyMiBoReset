import Foundation

enum ReminderNotifications {
    static let settingsChanged = Notification.Name("EyMiBoReset.ReminderSettingsChanged")
}

/// Single source of truth for the independent reminders (eyes / mind / body / hydration).
///
/// Owns the user-facing copy, the menu-bar label, and the stable identifier so the
/// reminder service, the menu-bar countdown rows, and notifications never drift apart.
enum Reminder: String, CaseIterable {
    case blink
    case posture
    case water
    case move
    case stretch
    case wrist
    case breathing

    /// Stable identifier used for notification request ids and persistence.
    var identifier: String { rawValue }

    /// Title shown in the on-screen popup and Notification Center.
    var notificationTitle: String {
        switch self {
        case .blink: return "Blink"
        case .posture: return "Straighten your back"
        case .water: return "Drink water"
        case .move: return "Move"
        case .stretch: return "Stretch"
        case .wrist: return "Wrist break"
        case .breathing: return "Breathe"
        }
    }

    /// Supporting copy shown beneath the title.
    var notificationBody: String {
        switch self {
        case .blink: return "Quick blink check."
        case .posture: return "Relax your shoulders and sit up straight."
        case .water: return "Take a few sips of water."
        case .move: return "Stand up or change position for a minute."
        case .stretch: return "Quick stretch: neck, shoulders, and back."
        case .wrist: return "Relax your hands and stretch your wrists."
        case .breathing: return "Take 3 slow breaths."
        }
    }

    /// Short label used in the menu-bar countdown rows.
    var menuLabel: String {
        switch self {
        case .blink: return "Blink"
        case .posture: return "Straight back"
        case .water: return "Water"
        case .move: return "Move"
        case .stretch: return "Stretch"
        case .wrist: return "Wrist"
        case .breathing: return "Breathe"
        }
    }
}
