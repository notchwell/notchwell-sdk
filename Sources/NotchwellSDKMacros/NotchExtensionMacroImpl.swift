import SwiftSyntax
import SwiftSyntaxMacros

public struct NotchExtensionMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let manifestMember: DeclSyntax = """
        public static var __notchwellManifestSource: String { "@NotchExtension(...) (manifest emitted at build time)" }
        """
        return [manifestMember]
    }
}
