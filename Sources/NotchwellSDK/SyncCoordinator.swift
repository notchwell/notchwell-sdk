import Foundation
import Combine

public protocol SyncCoordinator: Sendable {
    func events(in: Range<Date>, from: [ProviderID]?) async -> [CalendarEvent]
    func tasks(matching: TaskFilter, from: [ProviderID]?) async -> [CalendarTask]

    func eventsPublisher(in: Range<Date>, from: [ProviderID]?) -> AnyPublisher<[CalendarEvent], Never>
    func tasksPublisher(matching: TaskFilter, from: [ProviderID]?) -> AnyPublisher<[CalendarTask], Never>

    func calendars(from: [ProviderID]?) async -> [CalendarRef]
    func taskLists(from: [ProviderID]?) async -> [TaskListRef]

    func createEvent(_ event: CalendarEvent, via: ProviderID) async throws -> CalendarEvent
    func updateEvent(_ event: CalendarEvent) async throws -> CalendarEvent
    func deleteEvent(_ event: CalendarEvent) async throws
    func createTask(_ task: CalendarTask, via: ProviderID) async throws -> CalendarTask
    func updateTask(_ task: CalendarTask) async throws -> CalendarTask
    func setTaskCompleted(_ task: CalendarTask, completed: Bool) async throws -> CalendarTask
    func deleteTask(_ task: CalendarTask) async throws

    func requestImmediateSync(provider: ProviderID?) async
    func providerStatuses() async -> [ProviderStatus]
}
