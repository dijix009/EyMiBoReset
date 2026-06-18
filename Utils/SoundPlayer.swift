import AppKit

@MainActor
final class SoundPlayer {
    static let shared = SoundPlayer()

    enum Name: String, CaseIterable {
        case glass = "Glass"
        case ping = "Ping"
        case pop = "Pop"
        case basso = "Basso"

        var displayName: String { rawValue }
    }

    func play(name: String, volume: Double) {
        let v = Float(min(max(0.0, volume), 1.0))
        let sound = NSSound(named: NSSound.Name(name))
        sound?.volume = v
        sound?.play()
    }
}
