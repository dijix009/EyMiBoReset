import AppKit

enum ScreenManager {
    static func screens() -> [NSScreen] {
        NSScreen.screens
    }
}
