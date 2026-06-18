import XCTest
@testable import EyMiBoReset

final class ReminderModelTests: XCTestCase {
    func testHasAllSevenReminders() {
        XCTAssertEqual(Reminder.allCases.count, 7)
    }

    func testIdentifiersAreUniqueAndStable() {
        let ids = Reminder.allCases.map(\.identifier)
        XCTAssertEqual(Set(ids).count, ids.count, "reminder identifiers must be unique")

        // The identifier is the raw value and is used in persisted notification ids,
        // so it must remain stable across releases.
        XCTAssertEqual(Reminder.blink.identifier, "blink")
        XCTAssertEqual(Reminder.water.identifier, "water")
        XCTAssertEqual(Reminder.breathing.identifier, "breathing")
    }

    func testUserFacingCopyIsNonEmpty() {
        for reminder in Reminder.allCases {
            XCTAssertFalse(reminder.notificationTitle.isEmpty, "\(reminder) notificationTitle")
            XCTAssertFalse(reminder.notificationBody.isEmpty, "\(reminder) notificationBody")
            XCTAssertFalse(reminder.menuLabel.isEmpty, "\(reminder) menuLabel")
        }
    }
}
