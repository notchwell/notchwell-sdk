import Foundation

public protocol StateStore: Sendable {
    func get<T: Codable & Sendable>(_ key: String, as: T.Type) async throws -> T?
    func set<T: Codable & Sendable>(_ key: String, value: T) async throws
    func delete(_ key: String) async throws
    func size() async -> Int
}

public enum StateStoreError: Error, Sendable {
    case storeFull
    case decodingFailed
    case backingStoreUnavailable
}
