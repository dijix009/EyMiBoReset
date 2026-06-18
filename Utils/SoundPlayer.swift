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

    /// `NSSound` does not retain itself while playing, so a sound left only as a local
    /// variable can deallocate before it finishes and get cut off (or never play). We keep
    /// the most recent sounds alive in a small bounded buffer — break start/end and the test
    /// button never fire rapidly, so a handful of slots comfortably outlives any single sound.
    private var recent: [NSSound] = []
    private let maxRetained = 6

    func play(name: String, volume: Double) {
        guard let sound = NSSound(named: NSSound.Name(name)) else { return }
        sound.volume = Float(min(max(0.0, volume), 1.0))

        recent.append(sound)
        if recent.count > maxRetained {
            recent.removeFirst(recent.count - maxRetained)
        }

        sound.play()
    }
}
