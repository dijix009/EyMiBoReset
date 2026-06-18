import AppKit

final class ReminderCountdownMenuItem: NSMenuItem {
    let kind: Reminder

    init(kind: Reminder) {
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
        title = "\(kind.menuLabel): \(TimeFormat.mmss(secondsRemaining))"
    }
}
