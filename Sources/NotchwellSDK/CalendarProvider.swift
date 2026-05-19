import Foundation

public struct ChangeBatch<Item: Sendable>: Sendable {
    public let created: [Item]
    public let updated: [Item]
    public let deletedIDs: [String]
    public let nextCursor: SyncCursor?

    public init(created: [Item] = [], updated: [Item] = [], deletedIDs: [String] = [], nextCursor: SyncCursor? = nil) {
        self.created = created
        self.updated = updated
        self.deletedIDs = deletedIDs
        self.nextCursor = nextCursor
    }
}

public typealias EventChangeBatch = ChangeBatch<CalendarEvent>
public typealias TaskChangeBatch = ChangeBatch<CalendarTask>

public protocol PushSubscription: Sendable {
    func cancel() async
}

public protocol CalendarProvider: Activity {
    static var providerID: ProviderID { get }
    var supportsRealtimePush: Bool { get }

    func listCalendars() async throws -> [CalendarRef]
    func fetchEvents(in range: Range<Date>, from calendars: [CalendarRef]?) async throws -> [CalendarEvent]
    func fetchEventChanges(since cursor: SyncCursor?) async throws -> EventChangeBatch
    func subscribeToEventChanges(handler: @escaping @Sendable (EventChangeBatch) -> Void) async throws -> any PushSubscription
    func createEvent(_ event: CalendarEvent, in calendar: CalendarRef) async throws -> CalendarEvent
    func updateEvent(_ event: CalendarEvent, ifVersion: String) async throws -> CalendarEvent
    func deleteEvent(_ event: CalendarEvent, ifVersion: String) async throws
}

public extension CalendarProvider {
    var supportsRealtimePush: Bool { false }
}
