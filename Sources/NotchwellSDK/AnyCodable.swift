import Foundation

public struct AnyCodable: Codable, Sendable, Hashable {
    public let value: Value

    public enum Value: Codable, Sendable, Hashable {
        case null
        case bool(Bool)
        case int(Int)
        case double(Double)
        case string(String)
        case array([AnyCodable])
        case object([String: AnyCodable])
    }

    public init(_ value: Value) { self.value = value }
    public init(_ bool: Bool) { self.value = .bool(bool) }
    public init(_ int: Int) { self.value = .int(int) }
    public init(_ double: Double) { self.value = .double(double) }
    public init(_ string: String) { self.value = .string(string) }
    public init(_ array: [AnyCodable]) { self.value = .array(array) }
    public init(_ object: [String: AnyCodable]) { self.value = .object(object) }
    public init() { self.value = .null }

    public init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if c.decodeNil() { self.value = .null; return }
        if let b = try? c.decode(Bool.self) { self.value = .bool(b); return }
        if let i = try? c.decode(Int.self) { self.value = .int(i); return }
        if let d = try? c.decode(Double.self) { self.value = .double(d); return }
        if let s = try? c.decode(String.self) { self.value = .string(s); return }
        if let a = try? c.decode([AnyCodable].self) { self.value = .array(a); return }
        if let o = try? c.decode([String: AnyCodable].self) { self.value = .object(o); return }
        throw DecodingError.typeMismatch(
            AnyCodable.self,
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Unsupported AnyCodable value"
            )
        )
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.singleValueContainer()
        switch value {
        case .null:       try c.encodeNil()
        case .bool(let b): try c.encode(b)
        case .int(let i):  try c.encode(i)
        case .double(let d): try c.encode(d)
        case .string(let s): try c.encode(s)
        case .array(let a):  try c.encode(a)
        case .object(let o): try c.encode(o)
        }
    }
}
