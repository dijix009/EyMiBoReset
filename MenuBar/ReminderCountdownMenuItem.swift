import AppKit

final class ReminderCountdownMenuItem: NSMenuItem {
    enum Kind {
        case blink
        case posture
        case water
        case move
        case stretch
        case wrist
        case breathing

        var label: String {
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

    let kind: Kind

    init(kind: Kind) {
        self.kind = kind
        super.init(title: "", action: nil, keyEquivalent: "")
        isEnabled = false
        isHidden = true
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(secondsRemaining: Int?) {
        guard let secondsRemaining else {
            isHidden = true
            return
        }

        isHidden = false
        title = "\(kind.label): \(TimeFormat.mmss(secondsRemaining))"
    }
}
