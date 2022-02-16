import Core

public struct DebugMenuGridOverlayFactory {
    public init() { }

    public func produce(environment: Environment) -> DebugMenuGridOverlay? {
        DebugMenuGridOverlayImpl(environment: environment)
    }
}
