import AppKit
import SwiftUI

@MainActor
final class OverlayWindowController {
    /// We intentionally keep overlay windows alive for the lifetime of the app.
    /// Closing/deallocating borderless screensaver-level windows can trigger KVO teardown crashes
    /// ("NSKVONotifying_...OverlayWindow") on some macOS versions.
    private var windows: [OverlayWindow] = []
    private var session: OverlaySession?

    /// Used to gate programmatic skipping while enforcing "skip after".
    private var skipAfterSeconds: Int = 0

    func showAll(
        duration: Int,
        allowSkip: Bool,
        skipAfterSeconds: Int,
        messageTitle: String,
        messageSubtitle: String,
        dimOpacity: Double,
        blurStyle: Int,
        showOnAllScreens: Bool,
        completion: @escaping @MainActor () -> Void
    ) {
        self.skipAfterSeconds = max(0, skipAfterSeconds)

        // Determine which screens to show on.
        let targetScreens: [NSScreen]
        if showOnAllScreens {
            targetScreens = NSScreen.screens
        } else {
            targetScreens = [NSScreen.main ?? NSScreen.screens.first].compactMap { $0 }
        }

        ensureWindowsMatchScreens(targetScreens)

        // Single shared session across all windows => one timer, one completion.
        let session = OverlaySession(duration: duration) { [weak self] in
            guard let self else { return }
            DispatchQueue.main.async {
                Task { @MainActor in
                    self.hideAll()
                    completion()
                }
            }
        }
        self.session = session

        for (idx, screen) in targetScreens.enumerated() {
            guard idx < windows.count else { continue }
            let window = windows[idx]
            window.setFrame(screen.frame, display: true)

            let rootView = OverlayView(
                session: session,
                title: messageTitle,
                subtitle: messageSubtitle,
                dimOpacity: min(max(0.0, dimOpacity), 1.0),
                allowSkip: allowSkip,
                skipAfterSeconds: max(0, skipAfterSeconds)
            )

            let hosting = NSHostingView(rootView: rootView)
            hosting.translatesAutoresizingMaskIntoConstraints = false

            if blurStyle == 0 {
                // No blur, just SwiftUI content.
                let container = NSView(frame: screen.frame)
                container.addSubview(hosting)
                NSLayoutConstraint.activate([
                    hosting.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                    hosting.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                    hosting.topAnchor.constraint(equalTo: container.topAnchor),
                    hosting.bottomAnchor.constraint(equalTo: container.bottomAnchor),
                ])
                window.contentView = container
            } else {
                // Provide blur via NSVisualEffectView at the AppKit level.
                let blurView = NSVisualEffectView(frame: screen.frame)
                blurView.material = .underWindowBackground
                blurView.blendingMode = .withinWindow
                blurView.state = .active

                blurView.addSubview(hosting)
                NSLayoutConstraint.activate([
                    hosting.leadingAnchor.constraint(equalTo: blurView.leadingAnchor),
                    hosting.trailingAnchor.constraint(equalTo: blurView.trailingAnchor),
                    hosting.topAnchor.constraint(equalTo: blurView.topAnchor),
                    hosting.bottomAnchor.constraint(equalTo: blurView.bottomAnchor),
                ])

                window.contentView = blurView
            }

            window.level = .screenSaver
            window.backgroundColor = .clear
            window.isOpaque = false
            window.hasShadow = false
            window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]

            orderFront(window)
        }

        session.start()
    }

    func hideAll() {
        windows.forEach { $0.orderOut(nil) }
        let old = session
        session = nil
        DispatchQueue.main.async { _ = old }
    }

    /// Attempt to skip the current break.
    /// Enforces skip-after-seconds if configured.
    func skipIfAllowed() {
        guard let session else { return }
        if skipAfterSeconds > 0 {
            guard session.elapsed >= skipAfterSeconds else { return }
        }
        session.skip()
    }

    // MARK: - Private

    private func ensureWindowsMatchScreens(_ screens: [NSScreen]) {
        // If screen count changes, recreate the window array.
        if windows.count != screens.count {
            windows.forEach { $0.orderOut(nil) }
            windows.removeAll()

            for screen in screens {
                let w = OverlayWindow(
                    contentRect: screen.frame,
                    styleMask: [.borderless],
                    backing: .buffered,
                    defer: false,
                    screen: screen
                )
                w.isReleasedWhenClosed = false
                windows.append(w)
            }
        }
    }

    private func orderFront(_ window: NSWindow) {
        // Fullscreen spaces can ignore orderFrontRegardless for inactive apps.
        if FullscreenDetector.isFrontmostAppFullscreen() {
            NSApp.activate(ignoringOtherApps: true)
            window.makeKeyAndOrderFront(nil)
        } else {
            window.orderFrontRegardless()
        }
    }
}
