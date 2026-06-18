import XCTest
@testable import EyMiBoReset

final class BundleIdParsingTests: XCTestCase {
    func testSplitsOnNewlinesCommasAndCarriageReturns() {
        let raw = "us.zoom.xos\ncom.microsoft.teams, com.apple.FaceTime\r\ncom.foo.bar"
        XCTAssertEqual(
            UserSettings.parseBundleIdList(raw),
            ["us.zoom.xos", "com.microsoft.teams", "com.apple.FaceTime", "com.foo.bar"]
        )
    }

    func testTrimsWhitespaceAndDropsEmptyEntries() {
        let raw = "  us.zoom.xos  \n\n ,  , \n com.apple.FaceTime "
        XCTAssertEqual(
            UserSettings.parseBundleIdList(raw),
            ["us.zoom.xos", "com.apple.FaceTime"]
        )
    }

    func testEmptyOrSeparatorOnlyInputYieldsEmptyArray() {
        XCTAssertTrue(UserSettings.parseBundleIdList("").isEmpty)
        XCTAssertTrue(UserSettings.parseBundleIdList("   \n , \r ").isEmpty)
    }
}
