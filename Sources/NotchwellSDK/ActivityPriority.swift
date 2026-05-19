import Foundation

public enum ActivityPriority: Int, Comparable, Codable, Sendable, Hashable, CaseIterable {
    case critical = 1
    case high     = 2
    case elevated = 3
    case normal   = 5
    case low      = 7

    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    public init(rfc5545Priority: Int) {
        switch rfc5545Priority {
        case 1:        self = .critical
        case 2:        self = .high
        case 3, 4:     self = .elevated
        case 5:        self = .normal
        case 6, 7, 8, 9: self = .low
        default:       self = .normal
        }
    }

    public var rfc5545Priority: Int { rawValue }

    public func promoted() -> ActivityPriority {
        switch self {
        case .low:      return .normal
        case .normal:   return .elevated
        case .elevated: return .high
        case .high:     return .critical
        case .critical: return .critical
        }
    }
}
