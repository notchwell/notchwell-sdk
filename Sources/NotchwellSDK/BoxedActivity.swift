import Foundation
import SwiftUI

public final class BoxedActivity: @unchecked Sendable {
    public let lifecycle: @Sendable (Lifecycle) async -> Void
    public let manifestJSON: String
    public let compactViewFactory: @MainActor () -> AnyView
    public let expandedViewFactory: @MainActor () -> AnyView

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
        self.compactViewFactory = { AnyView(activity.compact) }
        self.expandedViewFactory = { AnyView(activity.expanded) }
    }

    public enum Lifecycle: Sendable {
        case load, activate, deactivate, unload
    }
}


