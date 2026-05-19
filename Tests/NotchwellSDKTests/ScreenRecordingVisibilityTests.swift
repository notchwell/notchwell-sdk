import XCTest
@testable import NotchwellSDK

final class ScreenRecordingVisibilityTests: XCTestCase {
    func testRawValues() {
        XCTAssertEqual(ScreenRecordingVisibility.inheritGlobal.rawValue, "inheritGlobal")
        XCTAssertEqual(ScreenRecordingVisibility.alwaysVisible.rawValue, "alwaysVisible")
        XCTAssertEqual(ScreenRecordingVisibility.alwaysHidden.rawValue, "alwaysHidden")
    }

    func testCodableRoundTrip() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        for value in ScreenRecordingVisibility.allCases {
            let data = try encoder.encode(value)
            let decoded = try decoder.decode(ScreenRecordingVisibility.self, from: data)
            XCTAssertEqual(decoded, value)
        }
    }
}
