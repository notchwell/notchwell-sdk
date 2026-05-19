import Foundation

public enum ScreenRecordingVisibility: String, Codable, Sendable, Hashable, CaseIterable {
    case inheritGlobal
    case alwaysVisible
    case alwaysHidden
}
