import Foundation

@MainActor
final class PreBreakPopupSession: ObservableObject {
    @Published private(set) var remaining: Int

    private var timer: Timer?

    init(seconds: Int) {
        self.remaining = max(0, seconds)
    }

    func start() {
        timer?.invalidate()
        timer = nil

        guard remaining > 0 else { return }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                self.remaining = max(0, self.remaining - 1)
                if self.remaining <= 0 {
                    self.timer?.invalidate()
                    self.timer = nil
                }
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }
}
