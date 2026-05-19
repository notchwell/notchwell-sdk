@attached(member, names: arbitrary)
@attached(peer, names: named(notchwell_entry), named(notchwell_manifest_json))
public macro NotchExtension(
    identifier: String,
    displayName: String,
    version: String,
    author: String,
    permissions: [Permission],
    focusAware: Bool = false,
    screenRecordingVisibility: ScreenRecordingVisibility = .inheritGlobal,
    voiceIntents: [Any.Type] = []
) = #externalMacro(module: "NotchwellSDKMacros", type: "NotchExtensionMacro")
