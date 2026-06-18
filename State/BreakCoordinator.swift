import Foundation

/// Coordinates scheduling decisions (timers + smart pause gating) separately from UI.
///
/// This is a small step toward C (smart auto-pause) without complicating the state machine.
final class BreakCoordinator {
    private let activityMonitor = ActivityMonitor()

    /// Returns true if we should proceed with a break workflow now.
    func shouldProceedWithBreak() -> Bool {
        return !activityMonitor.shouldPauseBreaksRightNow()
    }
}
