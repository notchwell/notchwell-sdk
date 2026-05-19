import Foundation

public enum Permission: String, Codable, Sendable, CaseIterable, Hashable {
    case timer
    case state
    case network
    case background
    case focusModeAwareness
    case openExternalURL
    case userNotification
    case voiceIntent
    case calendarProvider
    case tasksProvider
    case calendarRead
    case calendarWrite
    case tasksRead
    case tasksWrite

    public var humanizedDescription: String {
        switch self {
        case .timer:               return "Run timers and tick at 1 Hz while visible"
        case .state:               return "Save and read its own data"
        case .network:             return "Make HTTPS requests to remote services"
        case .background:          return "Run in the background (uses battery)"
        case .focusModeAwareness:  return "React to your current Focus mode"
        case .openExternalURL:     return "Open external URLs"
        case .userNotification:    return "Post macOS notifications"
        case .voiceIntent:         return "Receive voice commands you've explicitly granted"
        case .calendarProvider:    return "Read and write your calendar via this provider"
        case .tasksProvider:       return "Read and write your tasks via this provider"
        case .calendarRead:        return "Read calendar events from installed providers"
        case .calendarWrite:       return "Create, update, and delete calendar events"
        case .tasksRead:           return "Read tasks from installed providers"
        case .tasksWrite:          return "Create, update, and delete tasks"
        }
    }

    public var hasUserVisibleCost: Bool {
        switch self {
        case .openExternalURL:
            return false
        case .timer, .state, .network, .background, .focusModeAwareness,
             .userNotification, .voiceIntent, .calendarProvider, .tasksProvider,
             .calendarRead, .calendarWrite, .tasksRead, .tasksWrite:
            return true
        }
    }
}

public enum PermissionError: Error, Sendable {
    case denied(Permission)
}
