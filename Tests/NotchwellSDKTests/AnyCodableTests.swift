import XCTest
@testable import NotchwellSDK

final class AnyCodableTests: XCTestCase {
    func testRoundTripPrimitives() throws {
        let cases: [AnyCodable] = [
            AnyCodable(),
            AnyCodable(true),
            AnyCodable(42),
            AnyCodable(3.14),
            AnyCodable("hello"),
        ]
        for c in cases {
            let data = try JSONEncoder().encode(c)
            let decoded = try JSONDecoder().decode(AnyCodable.self, from: data)
            XCTAssertEqual(c, decoded)
        }
    }

    func testRoundTripNestedObject() throws {
        let value = AnyCodable([
            "google.colorId": AnyCodable("10"),
            "google.isRecurring": AnyCodable(true),
            "google.recurrence": AnyCodable([AnyCodable("RRULE:FREQ=DAILY")]),
        ])
        let data = try JSONEncoder().encode(value)
        let decoded = try JSONDecoder().decode(AnyCodable.self, from: data)
        XCTAssertEqual(value, decoded)
    }
}
