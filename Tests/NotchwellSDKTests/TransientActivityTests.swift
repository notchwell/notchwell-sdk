import XCTest
import SwiftUI
@testable import NotchwellSDK

final class TransientActivityTests: XCTestCase {
    func testConstructionUnder60Seconds() {
        let t = TransientActivity(priority: .elevated, duration: .seconds(5)) {
            EarRight { Text("Break time") }
        }
        XCTAssertEqual(t.priority, .elevated)
        XCTAssertEqual(t.duration, .seconds(5))
    }

    func testConstructionAt60Seconds() {
        let t = TransientActivity(priority: .normal, duration: .seconds(60)) {
            EarRight { Text("Edge") }
        }
        XCTAssertEqual(t.duration, .seconds(60))
    }
}
