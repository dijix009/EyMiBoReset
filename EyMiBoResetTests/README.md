# EyMiBoResetTests

Unit tests for the app's pure, deterministic logic:

- `TimeFormatTests` — `TimeFormat.mmss` / `menuBarShort` formatting and clamping.
- `BundleIdParsingTests` — `UserSettings.parseBundleIdList` splitting/trimming/filtering.
- `ReminderModelTests` — the `Reminder` model (case count, stable unique identifiers, non-empty copy).

These files compile against the app target via `@testable import EyMiBoReset`, but the
repository does not yet contain a **test target** to run them. Adding a target edits
`project.pbxproj` in ways that are risky to hand-author, so it's a one-time manual step in
Xcode (about a minute):

## Add the test target (Xcode)

1. Open `EyMiBoReset.xcodeproj`.
2. **File ▸ New ▸ Target… ▸ Unit Testing Bundle.** Name it `EyMiBoResetTests`, language
   Swift, and set **Target to be Tested** to `EyMiBoReset`. Finish.
3. Xcode creates a new `EyMiBoResetTests` group with a sample file. **Delete** that sample
   (move to trash).
4. Right-click the `EyMiBoResetTests` group ▸ **Add Files to "EyMiBoReset"…**, select the
   three `*.swift` files in this folder, and ensure **Target Membership ▸ EyMiBoResetTests**
   is checked (not the app target).
5. Run with **⌘U**, or from the CLI:

   ```sh
   xcodebuild -project EyMiBoReset.xcodeproj \
     -scheme EyMiBoReset \
     -destination 'platform=macOS' \
     test CODE_SIGNING_ALLOWED=NO
   ```

Once the target exists, these tests run in CI and locally and will catch regressions in the
formatting/parsing/model logic (e.g. an off-by-one in `menuBarShort`, or a duplicated
reminder identifier).
