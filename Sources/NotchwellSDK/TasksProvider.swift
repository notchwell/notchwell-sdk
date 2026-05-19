import Foundation

public protocol TasksProvider: Activity {
    static var providerID: ProviderID { get }
    var supportsRealtimePush: Bool { get }

    func listTaskLists() async throws -> [TaskListRef]
    func fetchTasks(matching filter: TaskFilter, from lists: [TaskListRef]?) async throws -> [CalendarTask]
    func fetchTaskChanges(since cursor: SyncCursor?) async throws -> TaskChangeBatch
    func subscribeToTaskChanges(handler: @escaping @Sendable (TaskChangeBatch) -> Void) async throws -> any PushSubscription
    func createTask(_ task: CalendarTask, in list: TaskListRef) async throws -> CalendarTask
    func updateTask(_ task: CalendarTask, ifVersion: String) async throws -> CalendarTask
    func setTaskCompleted(_ task: CalendarTask, completed: Bool, ifVersion: String) async throws -> CalendarTask
    func deleteTask(_ task: CalendarTask, ifVersion: String) async throws
}

public extension TasksProvider {
    var supportsRealtimePush: Bool { false }
}
