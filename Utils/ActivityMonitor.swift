import AppKit

/// Monitors user activity context for "smart pause".
///
/// Implemented:
/// - Meetings/calls: pause if the frontmost app is in the meeting bundle-id list.
/// - Generic frontmost pause list.
/// - Gaming/video (heuristic): pause if frontmost app is in a configured list,
///   optionally only when the app is fullscreen.
///
/// Planned:
/// - Screen recording detection
/// - Video playback detection beyond bundle-id heuristics
final class ActivityMonitor {
    private let settings = UserSettings()

    func shouldPauseBreaksRightNow() -> Bool {
        guard let bundleId = NSWorkspace.shared.frontmostApplication?.bundleIdentifier else {
            return false
        }

        // Meetings / calls (default ON)
        if settings.pauseDuringMeetings {
            let meetings = Set(settings.meetingsBundleIdentifiers)
            if meetings.contains(bundleId) {
                return true
            }
        }

        // Gaming (heuristic)
        if settings.pauseDuringFullscreenGaming {
            let games = Set(settings.gamingBundleIdentifiers)
            if games.contains(bundleId) {
                if settings.gamingRequiresFullscreen {
                    if FullscreenDetector.isFrontmostAppFullscreen() {
                        return true
                    }
                } else {
                    return true
                }
            }
        }

        // Video apps (heuristic)
        if settings.pauseDuringVideoPlayback {
            let videos = Set(settings.videoBundleIdentifiers)
            if videos.contains(bundleId) {
                if settings.videoRequiresFullscreen {
                    if FullscreenDetector.isFrontmostAppFullscreen() {
                        return true
                    }
                } else {
                    return true
                }
            }
        }

        // Generic list
        if settings.pauseWhenFrontmostAppMatches {
            let paused = Set(settings.pausedBundleIdentifiers)
            if paused.contains(bundleId) {
                return true
            }
        }

        return false
    }
}
