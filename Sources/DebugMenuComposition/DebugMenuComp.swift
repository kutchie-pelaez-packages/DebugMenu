import ActivityComposition
import AppearanceManager
import Core
import CoreRIB
import CoreUI
import DebugGridOverlay
import DebugMenuDomains
import DebugMenuOverlay
import DebugMenuRIB
import LocalizationManager
import LogsExtractor
import PermissionsManager
import SessionManager
import Tweak
import TweakEmitter

public final class DebugMenuComp: DebugMenuDelegate, DebugMenuOverlayDelegate {
    public init(
        environment: Environment,
        customDomains: [DebugMenuCustomDomain],
        provider: DebugMenuProvider,
        activityComposition: ActivityComp,
        sessionManager: SessionManager,
        logsExtractor: LogsExtractor,
        appearanceManager: AppearanceManager,
        localizationManager: LocalizationManager,
        permissionsManager: PermissionsManager,
        wordingManager: TweakReceiver,
        additionalTweakReceivers: [TweakReceiver] = []
    ) {
        self.environment = environment
        self.customDomains = customDomains
        self.provider = provider
        self.activityComposition = activityComposition
        self.sessionManager = sessionManager
        self.logsExtractor = logsExtractor
        self.appearanceManager = appearanceManager
        self.localizationManager = localizationManager
        self.permissionsManager = permissionsManager

        register(
            tweakReceivers: [
                sessionManager,
                appearanceManager,
                localizationManager,
                wordingManager,
                permissionsManager,
                debugMenuGridOverlay
            ] + additionalTweakReceivers
        )
    }

    let environment: Environment
    let customDomains: [DebugMenuCustomDomain]
    let provider: DebugMenuProvider
    let activityComposition: ActivityComp
    let sessionManager: SessionManager
    let logsExtractor: LogsExtractor
    let appearanceManager: AppearanceManager
    let localizationManager: LocalizationManager
    let permissionsManager: PermissionsManager

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

    lazy var debugMenuGridOverlay: DebugMenuGridOverlay? = {
        DebugMenuGridOverlayFactory().produce(
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
            debugMenuGridOverlay,
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
            customDomains: customDomains,
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
