import XCTest
@testable import NotchwellSDK

final class ActivityPriorityTests: XCTestCase {
    func testRawValuesMatchRFC5545() {
        XCTAssertEqual(ActivityPriority.critical.rawValue, 1)
        XCTAssertEqual(ActivityPriority.high.rawValue,     2)
        XCTAssertEqual(ActivityPriority.elevated.rawValue, 3)
        XCTAssertEqual(ActivityPriority.normal.rawValue,   5)
        XCTAssertEqual(ActivityPriority.low.rawValue,      7)
    }

    func testComparableIsReversedFromRawValue() {
        XCTAssertLessThan(ActivityPriority.critical, ActivityPriority.low)
        XCTAssertLessThan(ActivityPriority.high, ActivityPriority.normal)
        XCTAssertGreaterThan(ActivityPriority.low, ActivityPriority.elevated)
    }

    func testRFC5545RoundTripForDefinedValues() {
        XCTAssertEqual(ActivityPriority(rfc5545Priority: 1), .critical)
        XCTAssertEqual(ActivityPriority(rfc5545Priority: 2), .high)
        XCTAssertEqual(ActivityPriority(rfc5545Priority: 3), .elevated)
        XCTAssertEqual(ActivityPriority(rfc5545Priority: 5), .normal)
        XCTAssertEqual(ActivityPriority(rfc5545Priority: 7), .low)
    }

    func testRFC5545MapsUndefinedZeroToNormal() {
        XCTAssertEqual(ActivityPriority(rfc5545Priority: 0), .normal)
    }

    func testRFC5545BandsMapsRange() {
        XCTAssertEqual(ActivityPriority(rfc5545Priority: 4), .elevated)
        XCTAssertEqual(ActivityPriority(rfc5545Priority: 6), .low)
        XCTAssertEqual(ActivityPriority(rfc5545Priority: 8), .low)
        XCTAssertEqual(ActivityPriority(rfc5545Priority: 9), .low)
    }

    func testRFC5545InvalidValuesMapToNormal() {
        XCTAssertEqual(ActivityPriority(rfc5545Priority: -1), .normal)
        XCTAssertEqual(ActivityPriority(rfc5545Priority: 10), .normal)
        XCTAssertEqual(ActivityPriority(rfc5545Priority: 999), .normal)
    }

    func testPromotedWalksNamedScale() {
        XCTAssertEqual(ActivityPriority.low.promoted(), .normal)
        XCTAssertEqual(ActivityPriority.normal.promoted(), .elevated)
        XCTAssertEqual(ActivityPriority.elevated.promoted(), .high)
        XCTAssertEqual(ActivityPriority.high.promoted(), .critical)
    }

    func testPromotedCapsAtCritical() {
        XCTAssertEqual(ActivityPriority.critical.promoted(), .critical)
    }

    func testCodableRoundTrip() throws {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        for priority in ActivityPriority.allCases {
            let data = try encoder.encode(priority)
            let decoded = try decoder.decode(ActivityPriority.self, from: data)
            XCTAssertEqual(decoded, priority)
        }
    }
}
