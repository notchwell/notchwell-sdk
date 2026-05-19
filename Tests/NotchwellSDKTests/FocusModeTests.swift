import XCTest
@testable import NotchwellSDK

final class FocusModeTests: XCTestCase {
    func testStandardModesCodableRoundTrip() throws {
        let modes: [FocusMode] = [.work, .personal, .doNotDisturb, .sleep, .fitness, .driving, .mindfulness, .gaming, .reading]
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        for mode in modes {
            let data = try encoder.encode(mode)
            let decoded = try decoder.decode(FocusMode.self, from: data)
            XCTAssertEqual(decoded, mode)
        }
    }

    func testCustomModeCodableRoundTrip() throws {
        let mode: FocusMode = .custom(name: "Reading Time")
        let data = try JSONEncoder().encode(mode)
        let decoded = try JSONDecoder().decode(FocusMode.self, from: data)
        XCTAssertEqual(decoded, mode)
    }

    func testDisplayName() {
        XCTAssertEqual(FocusMode.work.displayName, "Work")
        XCTAssertEqual(FocusMode.doNotDisturb.displayName, "Do Not Disturb")
        XCTAssertEqual(FocusMode.custom(name: "Reading").displayName, "Reading")
    }

    func testExtensionBehaviourDefaults() {
        let b = ExtensionBehaviour()
        XCTAssertTrue(b.visible)
        XCTAssertTrue(b.allowInteraction)
        XCTAssertEqual(b.pollIntervalScale, 1.0)
    }
}
