import AppKit
import CoreGraphics

/// Lightweight fullscreen heuristic.
///
/// We treat an app as "fullscreen" if it has an on-screen window whose bounds
/// (roughly) match the bounds of any NSScreen.
///
/// This is not perfect, but it’s good enough for "requires fullscreen" gating.
enum FullscreenDetector {
    static func isFrontmostAppFullscreen() -> Bool {
        guard let app = NSWorkspace.shared.frontmostApplication else { return false }
        return isAppFullscreen(pid: app.processIdentifier)
    }

    static func isAppFullscreen(pid: pid_t) -> Bool {
        guard let infoList = CGWindowListCopyWindowInfo([.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID) as? [[String: Any]] else {
            return false
        }

        let screens = NSScreen.screens.map { $0.frame }

        for info in infoList {
            guard let ownerPID = info[kCGWindowOwnerPID as String] as? Int, ownerPID == Int(pid) else { continue }
            guard let boundsDict = info[kCGWindowBounds as String] as? [String: Any] else { continue }
            let bounds = CGRect(dictionaryRepresentation: boundsDict as CFDictionary) ?? .zero

            // Ignore tiny/utility windows.
            guard bounds.width > 300, bounds.height > 200 else { continue }

            if screens.contains(where: { approxCovers(bounds, screen: $0) }) {
                return true
            }
        }

        return false
    }

    private static func approxCovers(_ window: CGRect, screen: CGRect) -> Bool {
        // Allow small deltas for title bars / rounding / menu bar.
        let dx = abs(window.origin.x - screen.origin.x)
        let dy = abs(window.origin.y - screen.origin.y)
        let dw = abs(window.size.width - screen.size.width)
        let dh = abs(window.size.height - screen.size.height)

        return dx < 8 && dy < 40 && dw < 8 && dh < 40
    }
}
