import AppKit
import SwiftUI

/// Presents the Settings UI from non-SwiftUI contexts (menu bar).
///
/// We intentionally manage our own NSWindow so we don't rely on private/SDK-variant
/// selectors like `showSettingsWindow:`.
@MainActor
final class SettingsWindowController: NSObject, NSWindowDelegate {
    static let shared = SettingsWindowController()

    private var window: NSWindow?
    private var previousActivationPolicy: NSApplication.ActivationPolicy?

    func show() {
        if window == nil {
            let hosting = NSHostingController(rootView: SettingsRootView())

            let w = NSWindow(contentViewController: hosting)
            w.title = "Settings"
            // Opaque titlebar (always) + content uses the same window background color.
            // We keep fullSizeContentView so the content can scroll under the titlebar,
            // but the titlebar itself is opaque so it masks the content (System Settings behavior).
            w.styleMask = [.titled, .closable, .miniaturizable, .fullSizeContentView]
            w.titlebarAppearsTransparent = false
            w.isMovableByWindowBackground = true
            w.isReleasedWhenClosed = false
            w.delegate = self

            // System Settings-like split background:
            // - Window/detail area is opaque
            // - Sidebar provides vibrancy
            w.isOpaque = true
            w.backgroundColor = NSColor.windowBackgroundColor

            // Nice macOS feel.
            w.toolbarStyle = .unifiedCompact

            // Do not use the window-wide titlebar separator because it draws across the sidebar too.
            // We'll draw a separator only for the detail panel in SwiftUI.
            if #available(macOS 11.0, *) {
                w.titlebarSeparatorStyle = .none
            }

            w.center()
            window = w
        }

        // LSUIElement apps can fail to come to the front reliably.
        // Temporarily switch to .regular while Settings is open.
        if previousActivationPolicy == nil {
            previousActivationPolicy = NSApp.activationPolicy()
        }
        _ = NSApp.setActivationPolicy(.regular)

        // Bring Settings to the front reliably.
        NSRunningApplication.current.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])
        window?.makeKeyAndOrderFront(nil)
        window?.orderFrontRegardless()
    }

    func windowWillClose(_ notification: Notification) {
        // Restore prior activation policy so the app behaves like a menu-bar app again.
        if let prev = previousActivationPolicy {
            _ = NSApp.setActivationPolicy(prev)
        }
        previousActivationPolicy = nil
    }
}

enum SettingsWindow {
    @MainActor
    static func show() {
        SettingsWindowController.shared.show()
    }
}
