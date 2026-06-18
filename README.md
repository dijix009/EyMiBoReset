# EyMiBo Reset

**Smart breaks for focused work — a lightweight macOS menu-bar app.**

EyMiBo Reset (**Ey**es · **Mi**nd · **Bo**dy) helps you take regular, healthy breaks while
you work. It follows the **20-20-20 rule** by default — every 20 minutes, look ~20 feet away
for 20 seconds — and layers in optional micro-reminders for posture, hydration, movement, and
breathing. It stays out of your way in the menu bar (no Dock icon) and quietly pauses itself
when you're in a meeting or playing full-screen.

> The menu-bar item shows as **EMB** (text or a small icon, your choice).

## Features

**Scheduled eye breaks**
- Configurable work interval and break duration (defaults: 20 min work / 20 sec break).
- A pre-break countdown popup with **Start now / Snooze / Skip**, plus a Notification Center
  fallback — if you ignore it, the break starts automatically.
- A full-screen break overlay with a live countdown, optional dim + blur, a custom
  message, and an optional **“Skip available after N seconds”** gate.
- Shows on all screens or just the main one; optional start/end sounds.

**Independent wellness reminders**
- **Eyes:** blink · **Mind:** breathing · **Body:** straight back, move, stretch, wrist ·
  **Hydration:** drink water.
- Each has its own interval, an optional menu-bar countdown, and a gentle on-screen popup
  (passive, or interactive with a snooze button) backed by a notification.
- Reminders run during work time, pause during breaks, and reset afterward.
- One-click **presets** (e.g. “Office health”) plus save/load of your own.
- Snooze all reminders for 15 / 30 / 60 minutes from the menu.

**Smart Pause**
- Automatically pauses breaks during video calls (Zoom, Teams, FaceTime by default),
  full-screen gaming, video playback, or any app you add to a custom list.
- Browser apps are intentionally **not** paused by default, so breaks still fire.

**Polish**
- System Settings-style preferences window with a sidebar.
- Correct behavior across display sleep/wake and screen lock/unlock.
- Reminder popup placement (9 positions), duration, and interactivity are all configurable.

> **Roadmap / coming soon (stubbed in the UI):** screen-recording detection for Smart Pause,
> and automations (run a Shortcut / AppleScript on break start/end).

## Build it yourself

**Requirements**
- macOS 13 (Ventura) or later to run.
- Xcode 16 or later to build (developed with Xcode 26.3, Swift 6).

**With Xcode (recommended)**
1. Clone the repo and open `EyMiBoReset.xcodeproj`.
2. Select the **EyMiBoReset** scheme and press **⌘R** to build and run.

On first launch the app lives in the menu bar (it's an `LSUIElement` agent app, so there's no
Dock icon) and opens Settings so you can configure your timers and reminders.

**From the command line**
```sh
xcodebuild -project EyMiBoReset.xcodeproj \
  -scheme EyMiBoReset \
  -configuration Debug \
  -destination 'platform=macOS' \
  build CODE_SIGNING_ALLOWED=NO
```
`CODE_SIGNING_ALLOWED=NO` lets you build locally without a signing identity. For distribution
(notarization / App Store) you'll need to enable code signing and set up provisioning yourself.

**Tests**
Unit tests for the pure logic live in [`EyMiBoResetTests/`](EyMiBoResetTests/). They need a
test target added once in Xcode — see [`EyMiBoResetTests/README.md`](EyMiBoResetTests/README.md)
for the one-minute setup, then run with **⌘U** or:
```sh
xcodebuild -project EyMiBoReset.xcodeproj -scheme EyMiBoReset \
  -destination 'platform=macOS' test CODE_SIGNING_ALLOWED=NO
```

## Project layout

| Folder | Responsibility |
| --- | --- |
| `State/` | Break state machine and scheduling coordinator |
| `Timer/` | Work-interval timer |
| `Overlay/` | Full-screen break overlay window + session |
| `Break/` | Pre-break countdown popup |
| `Reminders/` | Independent reminder scheduling, popup, and the `Reminder` model |
| `Notifications/` | Notification Center integration |
| `MenuBar/` | Status-bar item, menu, and countdown rows |
| `Settings/` | Preferences UI and the `UserSettings` store (UserDefaults) |
| `Utils/` | Activity/fullscreen detection, sound, time formatting |
