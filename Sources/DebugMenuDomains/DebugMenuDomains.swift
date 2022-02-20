import Core

public struct DebugMenuDomains {
    public init(
        generalDomain: DebugMenuGeneralDomain?,
        gridDomain: DebugMenuGridDomain?,
        customDomains: [DebugMenuCustomDomain]?,
        updatePublisherResolver: @escaping Resolver<VoidPublisher>
    ) {
        self.generalDomain = generalDomain
        self.gridDomain = gridDomain
        self.customDomains = customDomains
        self.updatePublisherResolver = updatePublisherResolver
    }

    public let generalDomain: DebugMenuGeneralDomain?
    public let gridDomain: DebugMenuGridDomain?
    public let customDomains: [DebugMenuCustomDomain]?
    public let updatePublisherResolver: Resolver<VoidPublisher>
}
