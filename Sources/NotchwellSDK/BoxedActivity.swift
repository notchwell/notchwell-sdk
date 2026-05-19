import Foundation

public final class BoxedActivity: @unchecked Sendable {
    public let lifecycle: @Sendable (Lifecycle) async -> Void
    public let manifestJSON: String

    public init<A: Activity & Sendable>(_ activity: A, manifestJSON: String = "") {
        self.lifecycle = { stage in
            switch stage {
            case .load:       await activity.load()
            case .activate:   await activity.activate()
            case .deactivate: await activity.deactivate()
            case .unload:     await activity.unload()
            }
        }
        self.manifestJSON = manifestJSON
    }

    public enum Lifecycle: Sendable {
        case load, activate, deactivate, unload
    }
}


