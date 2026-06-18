import Foundation

enum TimeFormat {
    static func mmss(_ seconds: Int) -> String {
        let s = max(0, seconds)
        let m = s / 60
        let r = s % 60
        return String(format: "%02d:%02d", m, r)
    }

    /// Menu bar friendly format:
    /// - >= 60s: "12 min"
    /// - < 60s: "45 sec"
    static func menuBarShort(_ seconds: Int) -> String {
        let s = max(0, seconds)
        if s >= 60 {
            let m = Int((Double(s) / 60.0).rounded(.up))
            return "\(m) min"
        } else {
            return "\(s) sec"
        }
    }
}
