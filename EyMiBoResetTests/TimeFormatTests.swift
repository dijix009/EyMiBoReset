import XCTest
@testable import EyMiBoReset

final class TimeFormatTests: XCTestCase {
    func testMMSSFormatsMinutesAndSeconds() {
        XCTAssertEqual(TimeFormat.mmss(0), "00:00")
        XCTAssertEqual(TimeFormat.mmss(5), "00:05")
        XCTAssertEqual(TimeFormat.mmss(65), "01:05")
        XCTAssertEqual(TimeFormat.mmss(600), "10:00")
        XCTAssertEqual(TimeFormat.mmss(3661), "61:01")
    }

    func testMMSSClampsNegativeToZero() {
        XCTAssertEqual(TimeFormat.mmss(-10), "00:00")
    }

    func testMenuBarShortUsesSecondsUnderOneMinute() {
        XCTAssertEqual(TimeFormat.menuBarShort(0), "0 sec")
        XCTAssertEqual(TimeFormat.menuBarShort(45), "45 sec")
        XCTAssertEqual(TimeFormat.menuBarShort(59), "59 sec")
    }

    func testMenuBarShortRoundsUpToWholeMinutes() {
        XCTAssertEqual(TimeFormat.menuBarShort(60), "1 min")
        XCTAssertEqual(TimeFormat.menuBarShort(61), "2 min")  // ceil(61 / 60)
        XCTAssertEqual(TimeFormat.menuBarShort(90), "2 min")  // ceil(1.5)
        XCTAssertEqual(TimeFormat.menuBarShort(120), "2 min")
    }

    func testMenuBarShortClampsNegativeToZero() {
        XCTAssertEqual(TimeFormat.menuBarShort(-5), "0 sec")
    }
}
