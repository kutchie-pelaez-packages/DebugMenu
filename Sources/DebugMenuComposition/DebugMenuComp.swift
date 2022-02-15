import AppearanceManager
import Core
import CoreRIB
import CoreUI
import DebugGridOverlay
import DebugMenuDomains
import DebugMenuOverlay
import DebugMenuRIB
import LocalizationManager
import SessionManager
import Tweak
import TweakEmitter

public final class DebugMenuComp: DebugMenuDelegate, DebugMenuOverlayDelegate {
    public init(
        environment: Environment,
        provider: DebugMenuProvider,
        sessionManager: SessionManager,
        appearanceManager: AppearanceManager,
        localizationManager: LocalizationManager,
        wordingManager: TweakReceiver,
        additionalTweakReceivers: [TweakReceiver] = []
    ) {
        self.environment = environment
        self.provider = provider
        self.sessionManager = sessionManager
        self.appearanceManager = appearanceManager
        self.localizationManager = localizationManager

        register(
            tweakReceivers: [
                sessionManager,
                appearanceManager,
                localizationManager,
                wordingManager,
                debugGridOverlay
            ] + additionalTweakReceivers
        )
    }

    let environment: Environment
    let provider: DebugMenuProvider
    let sessionManager: SessionManager
    let appearanceManager: AppearanceManager
    let localizationManager: LocalizationManager

    lazy var tweakEmitter: TweakEmitter = {
        TweakEmitterFactory().produce()
    }()

    private var debugMenuFactory: ScopedRouterFactory<DebugMenuArgs> {
        DebugMenuFactory().scoped { [unowned self] args in
            DebugMenuDependenciesImpl(
                parent: self,
                presentationContext: args.presentationContext,
                domains: args.domains,
                delegate: args.delegate
            )
        }
    }

    lazy var debugGridOverlay: DebugGridOverlay? = {
        DebugGridOverlayFactory().produce(
            environment: environment
        )
    }()

    private lazy var debugMenuOverlay: WindowOverlay? = {
        DebugMenuOverlayFactory().produce(
            environment: environment,
            delegate: self
        )
    }()

    // MARK: - Public

    public var overlays: [WindowOverlay] {
        return [
            debugGridOverlay,
            debugMenuOverlay
        ].unwrapped()
    }

    // MARK: -

    private func register(tweakReceivers: [TweakReceiver?]) {
        tweakReceivers.unwrapped().forEach(tweakEmitter.register)
    }

    private func produceDebugMenuRouter() -> Routable? {
        guard let source = provider.windowResolver().rootViewController?.topPresentedViewController else { return nil }

        let generalDomainFactory = DebugMenuGeneralDomainFactory(
            parent: self
        )
        let gridDomainFactory = DebugMenuGridDomainFactory(
            parent: self
        )
        let updatePublisherResolverFactory = DebugMenuUpdatePublisherResolverFactory(
            parent: self
        )

        let domains = DebugMenuDomains(
            generalDomain: generalDomainFactory.produce(),
            gridDomain: gridDomainFactory.produce(),
            updatePublisherResolver: updatePublisherResolverFactory.produce()
        )

        return debugMenuFactory.produce(
            dependencies: DebugMenuArgs(
                presentationContext: PopoverPresentationContext(
                    source: source,
                    detents: [.medium(), .large()],
                    selectedDetentIdentifier: .large,
                    largestUndimmedDetentIdentifier: .medium,
                    prefersScrollingExpandsWhenScrolledToEdge: false,
                    didDismiss: { [unowned self] in
                        self.dismissDebugMenu()
                    }
                ),
                domains: domains,
                delegate: self
            )
        )
    }

    private func presentDebugMenu() {
        guard let debugMenuRouter = produceDebugMenuRouter() else { return }

        provider.routerResolver().attach(debugMenuRouter)
    }

    private func dismissDebugMenu() {
        provider.routerResolver().detach(DebugMenuRouterIdentifiers.debugMenu)
    }

    // MARK: - DebugMenuDelegate

    public func debugMenuDidRequestClosing() {
        dismissDebugMenu()
    }

    // MARK: - DebugMenuOverlayDelegate

    public func debugMenuOverlayDidRequestAction() {
        let parentRouter = provider.routerResolver()

        if let debugMenuRouter = parentRouter.children.first(where: { $0.id == DebugMenuRouterIdentifiers.debugMenu }) {
            guard debugMenuRouter.stateSubject.value == .attached else { return }

            dismissDebugMenu()
        } else {
            presentDebugMenu()
        }
    }
}
