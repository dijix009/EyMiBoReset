import AppKit
import SwiftUI

@MainActor
final class PreBreakPopupWindowController {
    private var window: NSPanel?
    private var session: PreBreakPopupSession?

    func show(seconds: Int, onStart: @escaping () -> Void, onSnooze: @escaping () -> Void, onSkip: @escaping () -> Void) {
        ensureWindow()
        guard let window else { return }

        let session = PreBreakPopupSession(seconds: seconds)
        self.session = session

        let view = PreBreakPopupView(session: session, onStart: onStart, onSnooze: onSnooze, onSkip: onSkip)
        let hosting = NSHostingView(rootView: view)
        hosting.autoresizingMask = [.width, .height]
        window.contentView = hosting

        position(window: window)

        window.alphaValue = 0
        window.makeKeyAndOrderFront(nil)
        NSAnimationContext.runAnimationGroup { ctx in
            ctx.duration = 0.12
            window.animator().alphaValue = 1
        }

        session.start()
    }

    func hide() {
        session?.stop()
        session = nil

        guard let window else { return }

        NSAnimationContext.runAnimationGroup({ ctx in
            ctx.duration = 0.15
            window.animator().alphaValue = 0
        }, completionHandler: {
            DispatchQueue.main.async {
                window.orderOut(nil)
            }
        })
    }

    private func ensureWindow() {
        if window != nil { return }

        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 440, height: 140),
            styleMask: [.titled, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        panel.title = ""
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true

        panel.isFloatingPanel = true
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = true
        panel.hidesOnDeactivate = false

        self.window = panel
    }

    private func position(window: NSWindow) {
        guard let screen = NSScreen.main ?? NSScreen.screens.first else { return }
        let visible = screen.visibleFrame

        let w = window.frame.width
        let h = window.frame.height

        let x = visible.midX - (w / 2)
        let y = visible.maxY - h - 18

        window.setFrameOrigin(NSPoint(x: x, y: y))
    }
}
