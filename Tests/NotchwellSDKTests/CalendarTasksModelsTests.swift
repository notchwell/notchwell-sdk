import XCTest
@testable import NotchwellSDK

final class CalendarTasksModelsTests: XCTestCase {
    func testCalendarEventRoundTrip() throws {
        let event = CalendarEvent(
            id: "google-calendar:abc",
            title: "Standup",
            start: Date(timeIntervalSince1970: 1_700_000_000),
            end:   Date(timeIntervalSince1970: 1_700_001_800),
            isAllDay: false,
            location: "Zoom",
            notes: "Daily team sync",
            calendar: CalendarRef(id: "primary", name: "Primary"),
            attendees: [Attendee(email: "alice@example.com", responseStatus: .accepted)],
            status: .confirmed,
            version: "etag-v1",
            providerSpecific: ["google.colorId": AnyCodable("10")]
        )
        let data = try JSONEncoder().encode(event)
        let decoded = try JSONDecoder().decode(CalendarEvent.self, from: data)
        XCTAssertEqual(decoded, event)
    }

    func testTaskPriorityIsActivityPriority() {
        let task = CalendarTask(
            id: "google-tasks:1",
            title: "Reply to landlord",
            list: TaskListRef(id: "@default", name: "My Tasks"),
            priority: .high
        )
        XCTAssertEqual(task.priority, ActivityPriority.high)
        XCTAssertEqual(task.priority.rawValue, 2)
    }

    func testCalendarTaskRoundTrip() throws {
        let task = CalendarTask(
            id: "google-tasks:42",
            title: "Submit expenses",
            dueDate: Date(timeIntervalSince1970: 1_700_000_000),
            completedAt: nil,
            list: TaskListRef(id: "@default", name: "Inbox"),
            priority: .elevated,
            version: "etag-task-v1"
        )
        let data = try JSONEncoder().encode(task)
        let decoded = try JSONDecoder().decode(CalendarTask.self, from: data)
        XCTAssertEqual(decoded, task)
    }

    func testTaskFilterDefaults() {
        let filter = TaskFilter()
        XCTAssertNil(filter.listIDs)
        XCTAssertEqual(filter.completionState, .incomplete)
        XCTAssertNil(filter.dueOnOrBefore)
        XCTAssertNil(filter.minimumPriority)
    }
}
