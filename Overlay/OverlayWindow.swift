import AppKit

/// Borderless overlay window that is allowed to become key so SwiftUI controls (e.g. Skip button)
/// can receive events without AppKit warnings.
final class OverlayWindow: NSWindow {
    override var canBecomeKey: Bool { true }
    override var canBecomeMain: Bool { true }
}
