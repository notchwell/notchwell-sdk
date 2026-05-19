import SwiftUI

public struct EarLeft<Content: View>: CompactView {
    public let content: Content
    public init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    public var body: some View { content }
}

public struct EarRight<Content: View>: CompactView {
    public let content: Content
    public init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    public var body: some View { content }
}

public struct ExpandedPanel<Content: View>: ExpandedView {
    public let tab: String
    public let content: Content
    public init(tab: String, @ViewBuilder _ content: () -> Content) {
        self.tab = tab
        self.content = content()
    }
    public var body: some View { content }
}

public struct EmptyCompactView: CompactView {
    public init() {}
    public var body: some View { EmptyView() }
}

public struct EmptyExpandedView: ExpandedView {
    public init() {}
    public var body: some View { EmptyView() }
}
