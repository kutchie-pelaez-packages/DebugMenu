import CoreRIB
import DebugMenuDomains
import LocalizationManager
import LogsExtractor
import TweakEmitter

public protocol DebugMenuDependencies {
    var presentationContext: PresentationContext { get }
    var domains: DebugMenuDomains { get }
    var delegate: DebugMenuDelegate { get }
    var tweakEmitter: TweakEmitter { get }
    var localizationManager: LocalizationManager { get }
    var logsExtractor: LogsExtractor { get }
}

public struct DebugMenuArgs {
    public init(
        presentationContext: PresentationContext,
        domains: DebugMenuDomains,
        delegate: DebugMenuDelegate
    ) {
        self.presentationContext = presentationContext
        self.domains = domains
        self.delegate = delegate
    }
    public let presentationContext: PresentationContext
    public let domains: DebugMenuDomains
    public let delegate: DebugMenuDelegate
}

public protocol DebugMenuDelegate: AnyObject {
    func debugMenuDidRequestClosing()
}

public struct DebugMenuFactory: RouterFactory {
    public init() { }

    public func produce(dependencies: DebugMenuDependencies) -> Routable {
        let interactor = DebugMenuInteractorImpl(
            domains: dependencies.domains,
            logsExtractor: dependencies.logsExtractor,
            delegate: dependencies.delegate
        )

        let sectionBuilder = DebugMenuSectionBuilderImpl(
            interactor: interactor,
            tweakEmitter: dependencies.tweakEmitter,
            localizationManager: dependencies.localizationManager
        )
        
        let viewController = DebugMenuViewControllerImpl(
            interactor: interactor
        )

        let router = DebugMenuRouterImpl(
            interactor: interactor,
            viewController: viewController,
            logsExtractor: dependencies.logsExtractor,
            delegate: dependencies.delegate,
            presentationContext: dependencies.presentationContext
        )

        interactor.router = router
        interactor.viewController = viewController
        interactor.sectionBuilder = sectionBuilder

        viewController.invokeWhenViewIsLoaded {
            interactor.start()
        }

        return router
    }
}
