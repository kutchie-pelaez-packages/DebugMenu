import Core

public struct DebugMenuDomains {
    public init(
        generalDomain: DebugMenuGeneralDomain?,
        gridDomain: DebugMenuGridDomain?,
        updatePublisherResolver: @escaping Resolver<VoidPublisher>
    ) {
        self.generalDomain = generalDomain
        self.gridDomain = gridDomain
        self.updatePublisherResolver = updatePublisherResolver
    }

    public let generalDomain: DebugMenuGeneralDomain?
    public let gridDomain: DebugMenuGridDomain?
    public let updatePublisherResolver: Resolver<VoidPublisher>
}
