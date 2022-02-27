import ActivityRIB
import CoreRIB
import LogsExtractor
import UIKit

private final class DebugMenuViewNavigationController: UINavigationController, PopoverViewControllerCompatible {
    var canCloseAsPopover: Bool { true }
}

protocol DebugMenuRouter: AnyObject {
    func routeToLogs()
    func routeToActivity(with text: String)
}

final class DebugMenuRouterImpl: Router, DebugMenuRouter, ActivityDelegate {
    init(
        interactor: DebugMenuInteractor,
        viewController: DebugMenuViewController,
        logsExtractor: LogsExtractor,
        delegate: DebugMenuDelegate,
        presentationContext: PresentationContext,
        activityFactory: ScopedRouterFactory<ActivityArgs>
    ) {
        self.interactor = interactor
        self.viewController = viewController
        self.logsExtractor = logsExtractor
        self.delegate = delegate
        self.presentationContext = presentationContext
        self.activityFactory = activityFactory
        super.init(id: DebugMenuRouterIdentifiers.debugMenu)
    }

    private let interactor: DebugMenuInteractor
    private let viewController: DebugMenuViewController
    private let logsExtractor: LogsExtractor
    private weak var delegate: DebugMenuDelegate?
    private let presentationContext: PresentationContext
    private let activityFactory: ScopedRouterFactory<ActivityArgs>

    private lazy var navigationController: UINavigationController = {
        let navigationController = DebugMenuViewNavigationController(
            rootViewController: viewController
        )
        navigationController.navigationBar.prefersLargeTitles = false

        return navigationController
    }()

    // MARK: - Router

    override func didRequestAttaching() async {
        await presentationContext.present(navigationController)
    }

    override func didRequestDetaching() async {
        await presentationContext.dismiss(navigationController)
    }

    // MARK: - DebugMenuRouter

    func routeToLogs() {
        let debugMenuLogsInteractor = DebugMenuLogsInteractorImpl(
            logsExtractor: logsExtractor,
            delegate: delegate
        )
        let debugMenuLogsViewController = DebugMenuLogsViewControllerImpl(
            interactor: debugMenuLogsInteractor
        )

        debugMenuLogsInteractor.viewController = debugMenuLogsViewController

        debugMenuLogsViewController.invokeWhenViewIsLoaded {
            debugMenuLogsInteractor.start()
        }

        navigationController.pushViewController(
            debugMenuLogsViewController,
            animated: true
        )
    }

    func routeToActivity(with text: String) {
        let activityItem = ActivityItem(text)
        let activityRouter = activityFactory.produce(
            dependencies: ActivityArgs(
                items: [activityItem],
                source: navigationController,
                trackToAnalytics: false,
                delegate: self
            )
        )

        attach(activityRouter)
    }

    // MARK: - ActivityDelegate

    func activityDidRequestClosing() {
        detach(ActivityRouterIdentifiers.activity)
    }
}
