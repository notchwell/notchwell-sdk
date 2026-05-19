import SwiftSyntax
import SwiftSyntaxMacros

public struct NotchExtensionMacro: MemberMacro, PeerMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let args = try MacroArguments(from: node)
        let manifest = args.manifestJSONStringLiteral()
        let typeName = try extractTypeName(from: declaration)

        let manifestMember: DeclSyntax = """
        public static let manifestJSON: String = \(raw: manifest)
        """

        let factoryMember: DeclSyntax = """
        public static func _notchwellMakeBoxedActivity() -> UnsafeMutableRawPointer {
            let boxed = NotchwellSDK.BoxedActivity(\(raw: typeName)())
            return Unmanaged.passRetained(boxed).toOpaque()
        }
        """

        return [manifestMember, factoryMember]
    }

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let typeName = try extractTypeName(from: declaration)

        let cEntry: DeclSyntax = """
        @_cdecl("notchwell_entry")
        public func notchwell_entry() -> UnsafeMutableRawPointer {
            return \(raw: typeName)._notchwellMakeBoxedActivity()
        }
        """

        let manifestEntry: DeclSyntax = """
        @_cdecl("notchwell_manifest_json")
        public func notchwell_manifest_json() -> UnsafePointer<CChar> {
            let json = \(raw: typeName).manifestJSON
            let buffer = UnsafeMutablePointer<CChar>.allocate(capacity: json.utf8.count + 1)
            _ = json.withCString { src in strcpy(buffer, src) }
            return UnsafePointer(buffer)
        }
        """

        return [cEntry, manifestEntry]
    }

    private static func extractTypeName(from declaration: some SyntaxProtocol) throws -> String {
        if let structDecl = declaration.as(StructDeclSyntax.self) {
            return structDecl.name.text
        }
        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            return classDecl.name.text
        }
        throw MacroExpansionError.unsupportedDeclaration
    }
}

struct MacroArguments {
    let identifier: String
    let displayName: String
    let version: String
    let author: String
    let permissions: [String]
    let focusAware: Bool
    let screenRecordingVisibility: String
    let voiceIntents: [String]

    init(from attribute: AttributeSyntax) throws {
        guard let argList = attribute.arguments?.as(LabeledExprListSyntax.self) else {
            throw MacroExpansionError.missingArguments
        }

        var ident: String?
        var disp: String?
        var ver: String?
        var auth: String?
        var perms: [String] = []
        var focus = false
        var visibility = "inheritGlobal"
        var intents: [String] = []

        for entry in argList {
            guard let label = entry.label?.text else { continue }
            switch label {
            case "identifier":  ident = stringValue(of: entry.expression)
            case "displayName": disp = stringValue(of: entry.expression)
            case "version":     ver = stringValue(of: entry.expression)
            case "author":      auth = stringValue(of: entry.expression)
            case "permissions": perms = arrayMemberAccessValues(of: entry.expression)
            case "focusAware":  focus = boolValue(of: entry.expression)
            case "screenRecordingVisibility":
                if let v = memberAccessName(of: entry.expression) { visibility = v }
            case "voiceIntents": intents = arrayTypeNames(of: entry.expression)
            default: continue
            }
        }

        guard let identifier = ident, !identifier.isEmpty else {
            throw MacroExpansionError.missingArgument("identifier")
        }
        guard let displayName = disp, !displayName.isEmpty else {
            throw MacroExpansionError.missingArgument("displayName")
        }
        guard let version = ver, !version.isEmpty else {
            throw MacroExpansionError.missingArgument("version")
        }
        guard let author = auth, !author.isEmpty else {
            throw MacroExpansionError.missingArgument("author")
        }

        self.identifier = identifier
        self.displayName = displayName
        self.version = version
        self.author = author
        self.permissions = perms
        self.focusAware = focus
        self.screenRecordingVisibility = visibility
        self.voiceIntents = intents
    }

    func manifestJSONStringLiteral() -> String {
        var permissionsJSON = "["
        permissionsJSON += permissions.map { "\\\"\($0)\\\"" }.joined(separator: ",")
        permissionsJSON += "]"

        var intentsJSON = "["
        intentsJSON += voiceIntents.map { "{\\\"identifier\\\":\\\"\($0)\\\",\\\"hints\\\":[]}" }.joined(separator: ",")
        intentsJSON += "]"

        let manifest = "{\\\"manifestVersion\\\":4,\\\"identifier\\\":\\\"\(identifier)\\\",\\\"displayName\\\":\\\"\(displayName)\\\",\\\"version\\\":\\\"\(version)\\\",\\\"author\\\":\\\"\(author)\\\",\\\"sdkVersion\\\":\\\"1.0.0\\\",\\\"permissions\\\":\(permissionsJSON),\\\"focusAware\\\":\(focusAware),\\\"screenRecordingVisibility\\\":\\\"\(screenRecordingVisibility)\\\",\\\"supportsRealtimePush\\\":false,\\\"providerDomains\\\":[],\\\"voiceIntents\\\":\(intentsJSON)}"
        return "\"\(manifest)\""
    }
}

enum MacroExpansionError: Error, CustomStringConvertible {
    case missingArguments
    case missingArgument(String)
    case unsupportedDeclaration

    var description: String {
        switch self {
        case .missingArguments:        return "@NotchExtension requires arguments"
        case .missingArgument(let n):  return "@NotchExtension requires argument: \(n)"
        case .unsupportedDeclaration:  return "@NotchExtension can only be applied to a struct or class"
        }
    }
}

private func stringValue(of expr: ExprSyntax) -> String? {
    expr.as(StringLiteralExprSyntax.self)?.segments.first?
        .as(StringSegmentSyntax.self)?.content.text
}

private func boolValue(of expr: ExprSyntax) -> Bool {
    guard let booleanLiteral = expr.as(BooleanLiteralExprSyntax.self) else { return false }
    return booleanLiteral.literal.text == "true"
}

private func memberAccessName(of expr: ExprSyntax) -> String? {
    expr.as(MemberAccessExprSyntax.self)?.declName.baseName.text
}

private func arrayMemberAccessValues(of expr: ExprSyntax) -> [String] {
    guard let array = expr.as(ArrayExprSyntax.self) else { return [] }
    return array.elements.compactMap { element in
        memberAccessName(of: element.expression)
    }
}

private func arrayTypeNames(of expr: ExprSyntax) -> [String] {
    guard let array = expr.as(ArrayExprSyntax.self) else { return [] }
    return array.elements.compactMap { element in
        if let metatype = element.expression.as(MemberAccessExprSyntax.self),
           metatype.declName.baseName.text == "self",
           let base = metatype.base?.as(DeclReferenceExprSyntax.self) {
            return base.baseName.text
        }
        return nil
    }
}
