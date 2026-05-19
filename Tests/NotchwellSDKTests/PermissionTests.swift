import XCTest
@testable import NotchwellSDK

final class PermissionTests: XCTestCase {
    func testAllCasesAreCodable() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        for permission in Permission.allCases {
            let data = try encoder.encode(permission)
            let decoded = try decoder.decode(Permission.self, from: data)
            XCTAssertEqual(decoded, permission)
        }
    }

    func testHumanizedDescriptionIsPopulated() {
        for permission in Permission.allCases {
            XCTAssertFalse(permission.humanizedDescription.isEmpty)
        }
    }

    func testOpenExternalURLIsTheOnlyZeroCostPermission() {
        let zeroCost = Permission.allCases.filter { !$0.hasUserVisibleCost }
        XCTAssertEqual(zeroCost, [.openExternalURL])
    }

    func testAllCasesOrderIsStable() {
        let expected: [Permission] = [
            .timer, .state, .network, .background, .focusModeAwareness,
            .openExternalURL, .userNotification, .voiceIntent,
            .calendarProvider, .tasksProvider,
            .calendarRead, .calendarWrite, .tasksRead, .tasksWrite,
        ]
        XCTAssertEqual(Permission.allCases, expected)
    }
}
