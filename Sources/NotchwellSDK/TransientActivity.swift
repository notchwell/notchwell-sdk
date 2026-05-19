import Foundation
import SwiftUI

public struct TransientActivity<Compact: CompactView>: Sendable where Compact: Sendable {
    public let priority: ActivityPriority
    public let duration: Duration
    public let screenRecordingVisibility: ScreenRecordingVisibility?
    public let compact: Compact

    public init(
        priority: ActivityPriority = .normal,
        duration: Duration = .seconds(5),
        screenRecordingVisibility: ScreenRecordingVisibility? = nil,
        @ViewBuilder compact: () -> Compact
    ) {
        precondition(
            duration <= .seconds(60),
            "TransientActivity.duration is capped at 60 seconds"
        )
        self.priority = priority
        self.duration = duration
        self.screenRecordingVisibility = screenRecordingVisibility
        self.compact = compact()
    }
}
