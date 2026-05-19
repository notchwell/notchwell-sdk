import Foundation

public struct ProviderID: RawRepresentable, Codable, Sendable, Hashable {
    public let rawValue: String
    public init(rawValue: String) { self.rawValue = rawValue }
    public init(_ rawValue: String) { self.rawValue = rawValue }
}

public typealias TaskPriority = ActivityPriority

public struct CalendarRef: Codable, Sendable, Hashable, Identifiable {
    public let id: String
    public var name: String
    public var color: String?
    public var isWritable: Bool

    public init(id: String, name: String, color: String? = nil, isWritable: Bool = true) {
        self.id = id
        self.name = name
        self.color = color
        self.isWritable = isWritable
    }
}

public struct TaskListRef: Codable, Sendable, Hashable, Identifiable {
    public let id: String
    public var name: String
    public var isWritable: Bool

    public init(id: String, name: String, isWritable: Bool = true) {
        self.id = id
        self.name = name
        self.isWritable = isWritable
    }
}

public enum ResponseStatus: String, Codable, Sendable, Hashable {
    case accepted
    case declined
    case tentative
    case needsAction
}

public struct Attendee: Codable, Sendable, Hashable {
    public var email: String
    public var displayName: String?
    public var responseStatus: ResponseStatus

    public init(email: String, displayName: String? = nil, responseStatus: ResponseStatus = .needsAction) {
        self.email = email
        self.displayName = displayName
        self.responseStatus = responseStatus
    }
}

public enum EventStatus: String, Codable, Sendable, Hashable {
    case confirmed
    case tentative
    case cancelled
}

public struct CalendarEvent: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var title: String
    public var start: Date
    public var end: Date
    public var isAllDay: Bool
    public var location: String?
    public var notes: String?
    public var calendar: CalendarRef
    public var attendees: [Attendee]
    public var status: EventStatus
    public var version: String
    public var providerSpecific: [String: AnyCodable]

    public init(
        id: String,
        title: String,
        start: Date,
        end: Date,
        isAllDay: Bool = false,
        location: String? = nil,
        notes: String? = nil,
        calendar: CalendarRef,
        attendees: [Attendee] = [],
        status: EventStatus = .confirmed,
        version: String = "",
        providerSpecific: [String: AnyCodable] = [:]
    ) {
        self.id = id
        self.title = title
        self.start = start
        self.end = end
        self.isAllDay = isAllDay
        self.location = location
        self.notes = notes
        self.calendar = calendar
        self.attendees = attendees
        self.status = status
        self.version = version
        self.providerSpecific = providerSpecific
    }
}

public struct CalendarTask: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public var title: String
    public var dueDate: Date?
    public var completedAt: Date?
    public var notes: String?
    public var list: TaskListRef
    public var priority: TaskPriority
    public var version: String
    public var providerSpecific: [String: AnyCodable]

    public init(
        id: String,
        title: String,
        dueDate: Date? = nil,
        completedAt: Date? = nil,
        notes: String? = nil,
        list: TaskListRef,
        priority: TaskPriority = .normal,
        version: String = "",
        providerSpecific: [String: AnyCodable] = [:]
    ) {
        self.id = id
        self.title = title
        self.dueDate = dueDate
        self.completedAt = completedAt
        self.notes = notes
        self.list = list
        self.priority = priority
        self.version = version
        self.providerSpecific = providerSpecific
    }

    public var isCompleted: Bool { completedAt != nil }
}

public struct TaskFilter: Codable, Sendable, Hashable {
    public enum CompletionState: String, Codable, Sendable, Hashable {
        case all
        case completed
        case incomplete
    }

    public var listIDs: [String]?
    public var completionState: CompletionState
    public var dueOnOrBefore: Date?
    public var minimumPriority: TaskPriority?

    public init(
        listIDs: [String]? = nil,
        completionState: CompletionState = .incomplete,
        dueOnOrBefore: Date? = nil,
        minimumPriority: TaskPriority? = nil
    ) {
        self.listIDs = listIDs
        self.completionState = completionState
        self.dueOnOrBefore = dueOnOrBefore
        self.minimumPriority = minimumPriority
    }
}

public struct SyncCursor: Codable, Sendable, Hashable {
    public let rawValue: String
    public let provider: ProviderID
    public init(rawValue: String, provider: ProviderID) {
        self.rawValue = rawValue
        self.provider = provider
    }
}

public enum SyncMode: String, Codable, Sendable, Hashable {
    case push
    case poll
}

public struct ProviderStatus: Codable, Sendable, Hashable {
    public let id: ProviderID
    public var displayName: String
    public var isAuthenticated: Bool
    public var signedInAs: String?
    public var lastSyncAt: Date?
    public var syncMode: SyncMode
    public var authError: String?

    public init(
        id: ProviderID,
        displayName: String,
        isAuthenticated: Bool,
        signedInAs: String? = nil,
        lastSyncAt: Date? = nil,
        syncMode: SyncMode = .poll,
        authError: String? = nil
    ) {
        self.id = id
        self.displayName = displayName
        self.isAuthenticated = isAuthenticated
        self.signedInAs = signedInAs
        self.lastSyncAt = lastSyncAt
        self.syncMode = syncMode
        self.authError = authError
    }
}
