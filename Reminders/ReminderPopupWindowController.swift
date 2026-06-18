import AppKit
import QuartzCore
import SwiftUI

@MainActor
final class ReminderPopupWindowController {
    private var window: NSPanel?
    private var hideWorkItem: DispatchWorkItem?
    private let settings = UserSettings()

    var onSnoozeTapped: (() -> Void)?

    func show(title: String, subtitle: String) {
        ensureWindow()
        guard let window else { return }

        let isInteractive = settings.reminderPopupInteractive
        let snoozeMinutes = max(1, settings.reminderPopupSnoozeMinutes)

        // Replace content each time.
        let hosting = NSHostingView(
            rootView: ReminderPopupView(
                title: title,
                subtitle: subtitle,
                isInteractive: isInteractive,
                snoozeMinutes: snoozeMinutes,
                onSnooze: isInteractive ? { [weak self] in
                    self?.onSnoozeTapped?()
                    self?.hide()
                } : nil,
                onDismiss: { [weak self] in
                    self?.hide()
                }
            )
        )
        window.contentView = hosting

        // Size the panel to the SwiftUI content so rounded corners aren't clipped.
        hosting.layoutSubtreeIfNeeded()
        let fit = hosting.fittingSize

        // Add padding around the SwiftUI content so the shadow isn't clipped by the window bounds.
        let shadowMargin: CGFloat = 34
        window.setContentSize(
            NSSize(
                width: max(280, fit.width + shadowMargin * 2),
                height: max(60, fit.height + shadowMargin * 2)
            )
        )

        applyInteractivity(window: window)
        position(window: window)

        // LookAway-ish: slide up + fade in.
        let targetFrame = window.frame
        var start = targetFrame
        start.origin.y -= 12

        window.setFrame(start, display: false)
        window.alphaValue = 0

        // Avoid makeKeyWindow warnings for non-activating panels.
        if settings.reminderPopupInteractive {
            window.makeKeyAndOrderFront(nil)
        } else {
            window.orderFrontRegardless()
        }

        NSAnimationContext.runAnimationGroup { ctx in
            ctx.duration = 0.22
            ctx.timingFunction = CAMediaTimingFunction(name: .easeOut)
            window.animator().setFrame(targetFrame, display: false)
            window.animator().alphaValue = 1
        }

        scheduleAutoHide()
    }

    private func scheduleAutoHide() {
        hideWorkItem?.cancel()

        let seconds = max(1, min(5, settings.reminderPopupDurationSeconds))
        let item = DispatchWorkItem { [weak self] in
            Task { @MainActor in
                self?.hide()
            }
        }
        hideWorkItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(seconds), execute: item)
    }

    func hide() {
        guard let window else { return }
        hideWorkItem?.cancel()
        hideWorkItem = nil

        // Slide up + fade out.
        let end = NSRect(
            x: window.frame.origin.x,
            y: window.frame.origin.y + 12,
            width: window.frame.size.width,
            height: window.frame.size.height
        )

        NSAnimationContext.runAnimationGroup({ ctx in
            ctx.duration = 0.18
            ctx.timingFunction = CAMediaTimingFunction(name: .easeIn)
            window.animator().setFrame(end, display: false)
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
            contentRect: NSRect(x: 0, y: 0, width: 340, height: 90),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.becomesKeyOnlyIfNeeded = true
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = true
        panel.hidesOnDeactivate = false
        // Interactivity is configured per-show (settings).
        panel.ignoresMouseEvents = false

        self.window = panel
    }

    private func applyInteractivity(window: NSPanel) {
        let interactive = settings.reminderPopupInteractive
        // Allow click-to-dismiss even when "interactive" is off.
        // In passive mode, the window is non-activating so it won't steal focus.
        window.ignoresMouseEvents = false

        if interactive {
            window.styleMask.remove(.nonactivatingPanel)
        } else {
            window.styleMask.insert(.nonactivatingPanel)
        }
    }

    private func position(window: NSWindow) {
        guard let screen = NSScreen.main ?? NSScreen.screens.first else { return }
        let visible = screen.visibleFrame

        let w = window.frame.width
        let h = window.frame.height

        let margin: CGFloat = 18

        func xLeft() -> CGFloat { visible.minX + margin }
        func xCenter() -> CGFloat { visible.midX - (w / 2) }
        func xRight() -> CGFloat { visible.maxX - w - margin }

        func yTop() -> CGFloat { visible.maxY - h - margin }
        func yCenter() -> CGFloat { visible.midY - (h / 2) }
        func yBottom() -> CGFloat { visible.minY + margin }

        let pos = settings.reminderPopupPosition
        let x: CGFloat
        let y: CGFloat

        switch pos {
        case .topLeft: x = xLeft(); y = yTop()
        case .topCenter: x = xCenter(); y = yTop()
        case .topRight: x = xRight(); y = yTop()
        case .centerLeft: x = xLeft(); y = yCenter()
        case .center: x = xCenter(); y = yCenter()
        case .centerRight: x = xRight(); y = yCenter()
        case .bottomLeft: x = xLeft(); y = yBottom()
        case .bottomCenter: x = xCenter(); y = yBottom()
        case .bottomRight: x = xRight(); y = yBottom()
        }

        window.setFrameOrigin(NSPoint(x: x, y: y))
    }
}
