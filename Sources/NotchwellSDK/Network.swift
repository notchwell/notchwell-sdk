import Foundation

public enum HTTPMethod: String, Codable, Sendable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
}

public struct HTTPResponse: Sendable {
    public let statusCode: Int
    public let headers: [String: String]
    public let body: Data

    public init(statusCode: Int, headers: [String: String], body: Data) {
        self.statusCode = statusCode
        self.headers = headers
        self.body = body
    }
}

public enum GoogleScope: String, Sendable {
    case calendar = "https://www.googleapis.com/auth/calendar"
    case calendarReadonly = "https://www.googleapis.com/auth/calendar.readonly"
    case tasks = "https://www.googleapis.com/auth/tasks"
    case tasksReadonly = "https://www.googleapis.com/auth/tasks.readonly"
}

public enum MicrosoftScope: String, Sendable {
    case calendarReadWrite = "https://graph.microsoft.com/Calendars.ReadWrite"
    case tasksReadWrite = "https://graph.microsoft.com/Tasks.ReadWrite"
}

public enum OAuthProvider: Sendable {
    case google(scopes: [GoogleScope])
    case microsoft(scopes: [MicrosoftScope])
    case generic(
        authorizationURL: URL,
        tokenURL: URL,
        clientID: String,
        scopes: [String]
    )
}

public struct OAuthToken: Sendable, Hashable {
    private let handle: UUID
    public init() { self.handle = UUID() }
    fileprivate init(handle: UUID) { self.handle = handle }
}

public enum NetworkError: Error, Sendable {
    case permissionDenied
    case authenticationRequired
    case authenticationFailed
    case rateLimited
    case transportFailure(underlying: String)
    case invalidResponse
}

public protocol Network: Sendable {
    func request(
        method: HTTPMethod,
        url: URL,
        headers: [String: String],
        body: Data?,
        usingToken: OAuthToken?
    ) async throws -> HTTPResponse

    func authenticate(_ provider: OAuthProvider) async throws -> OAuthToken
}
