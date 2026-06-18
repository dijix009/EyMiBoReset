import Foundation

final class BreakTimerService {
    private var timer: DispatchSourceTimer?
    private(set) var nextFireDate: Date?

    func startInterval(minutes: Int, handler: @escaping () -> Void) {
        start(after: .seconds(max(0, minutes) * 60), handler: handler)
    }

    func start(after delay: DispatchTimeInterval, handler: @escaping () -> Void) {
        invalidate()

        let seconds = Self.seconds(from: delay)
        nextFireDate = Date().addingTimeInterval(TimeInterval(seconds))

        let t = DispatchSource.makeTimerSource(queue: .main)
        t.schedule(deadline: .now() + delay)
        t.setEventHandler(handler: handler)
        t.resume()
        timer = t
    }

    func invalidate() {
        timer?.cancel()
        timer = nil
        nextFireDate = nil
    }

    var secondsRemaining: Int? {
        guard let nextFireDate else { return nil }
        return max(0, Int(nextFireDate.timeIntervalSinceNow.rounded(.down)))
    }

    private static func seconds(from delay: DispatchTimeInterval) -> Int {
        switch delay {
        case .seconds(let s): return s
        case .milliseconds(let ms): return Int((Double(ms) / 1000.0).rounded(.up))
        case .microseconds(let us): return Int((Double(us) / 1_000_000.0).rounded(.up))
        case .nanoseconds(let ns): return Int((Double(ns) / 1_000_000_000.0).rounded(.up))
        case .never: return Int.max
        @unknown default: return 0
        }
    }
}
