import Foundation

public protocol VoiceIntent: Codable, Sendable {
    static var identifier: String { get }
    static var hints: [String] { get }
    static var requiresConfirmation: Bool { get }
    static var isDestructive: Bool { get }
}

public extension VoiceIntent {
    static var requiresConfirmation: Bool { true }
    static var isDestructive: Bool { false }
}
