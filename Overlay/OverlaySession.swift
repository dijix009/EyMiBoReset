import Foundation
import SwiftUI

@MainActor
final class OverlaySession: ObservableObject {
    let duration: Int

    @Published private(set) var remaining: Int
    @Published private(set) var elapsed: Int = 0

    private var timer: Timer?
    private var didFinish = false
    private var startDate: Date?
    private let onFinish: @MainActor () -> Void

    init(duration: Int, onFinish: @escaping @MainActor () -> Void) {
        self.duration = max(0, duration)
        self.remaining = max(0, duration)
        self.onFinish = onFinish
    }

    func start() {
        guard timer == nil else { return }
        if remaining <= 0 {
            finish()
            return
        }

        startDate = Date()
        // Ensure initial values are consistent.
        tick()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                self.tick()
            }
        }
    }

    func skip() {
        finish()
    }

    private func tick() {
        guard !didFinish else { return }

        // Use wall-clock time so sleep/wake doesn't freeze the countdown.
        let now = Date()
        if let startDate {
            elapsed = max(0, Int(now.timeIntervalSince(startDate).rounded(.down)))
            remaining = max(0, duration - elapsed)
        } else {
            remaining = max(0, remaining - 1)
            elapsed = max(0, duration - remaining)
        }

        if remaining <= 0 {
            finish()
        }
    }

    private func finish() {
        guard !didFinish else { return }
        didFinish = true

        timer?.invalidate()
        timer = nil
        remaining = 0

        // Defer teardown to the next run loop turn to avoid re-entrancy / SwiftUI teardown races.
        DispatchQueue.main.async { [onFinish] in
            Task { @MainActor in
                onFinish()
            }
        }
    }
}
