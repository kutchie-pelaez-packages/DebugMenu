import Core
import CoreUI

public struct DebugMenuOverlayFactory {
    public init() { }

    public func produce(
        environment: Environment,
        delegate: DebugMenuOverlayDelegate
    ) -> WindowOverlay? {
        DebugMenuOverlayImpl(
            environment: environment,
            delegate: delegate
        )
    }
}
