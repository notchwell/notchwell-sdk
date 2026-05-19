import Foundation

public enum FocusMode: Hashable, Sendable, Codable {
    case work
    case personal
    case doNotDisturb
    case sleep
    case fitness
    case driving
    case mindfulness
    case gaming
    case reading
    case custom(name: String)

    public var displayName: String {
        switch self {
        case .work:          return "Work"
        case .personal:      return "Personal"
        case .doNotDisturb:  return "Do Not Disturb"
        case .sleep:         return "Sleep"
        case .fitness:       return "Fitness"
        case .driving:       return "Driving"
        case .mindfulness:   return "Mindfulness"
        case .gaming:        return "Gaming"
        case .reading:       return "Reading"
        case .custom(let n): return n
        }
    }
}

public struct ExtensionBehaviour: Codable, Sendable, Hashable {
    public var visible: Bool
    public var allowInteraction: Bool
    public var pollIntervalScale: Double

    public init(
        visible: Bool = true,
        allowInteraction: Bool = true,
        pollIntervalScale: Double = 1.0
    ) {
        self.visible = visible
        self.allowInteraction = allowInteraction
        self.pollIntervalScale = pollIntervalScale
    }
}
