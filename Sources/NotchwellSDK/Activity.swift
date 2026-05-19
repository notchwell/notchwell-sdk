import Foundation
import SwiftUI

public protocol CompactView: View {}
public protocol ExpandedView: View {}

public protocol Activity {
    associatedtype Compact: CompactView
    associatedtype Expanded: ExpandedView

    var compact: Compact { get }
    var expanded: Expanded { get }

    var priority: ActivityPriority { get }
    var screenRecordingVisibility: ScreenRecordingVisibility? { get }

    func load() async
    func activate() async
    func deactivate() async
    func unload() async
}

public extension Activity {
    var priority: ActivityPriority { .normal }
    var screenRecordingVisibility: ScreenRecordingVisibility? { nil }
    func load() async {}
    func activate() async {}
    func deactivate() async {}
    func unload() async {}
}

public protocol FocusAwareActivity: Activity {
    func behaviour(for focus: FocusMode) -> ExtensionBehaviour
}
