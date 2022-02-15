import Core

public struct DebugGridOverlayFactory {
    public init() { }

    public func produce(environment: Environment) -> DebugGridOverlay? {
        DebugGridOverlayImpl(environment: environment)
    }
}
