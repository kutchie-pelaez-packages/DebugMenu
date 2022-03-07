import ActivityRIB
import CoreRIB
import LogsExtractor
import UIKit

private final class DebugMenuViewNavigationController: UINavigationController, PopoverViewControllerCompatible {
    var canCloseAsPopover: Bool { true }
}

protocol DebugMenuRouter: AnyObject {
    func routeToLogs()
    func routeToDirectoryViewer(at url: URL)
    func routeToTextFileViewer(at url: URL)
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
        let logsInteractor = DebugMenuLogsInteractorImpl(logsExtractor: logsExtractor)
        let logsViewController = DebugMenuFileViewerController(title: "Logs") {
            self.delegate?.debugMenuDidRequestClosing()
        }
        logsViewController.invokeWhenViewIsLoaded {
            logsInteractor.start()
        }
        logsInteractor.viewController = logsViewController

        navigationController.pushViewController(
            logsViewController,
            animated: true
        )
    }

    func routeToDirectoryViewer(at url: URL) {
        let directoryViewerInteractor = DebugMenuDirectoryViewerInteractorImpl(
            url: url,
            delegate: delegate
        )
        let directoryViewerViewController = DebugMenuDirectoryViewerViewControllerImpl(interactor: directoryViewerInteractor)
        directoryViewerViewController.invokeWhenViewIsLoaded {
            directoryViewerInteractor.start()
        }
        directoryViewerInteractor.router = self
        directoryViewerInteractor.viewController = directoryViewerViewController

        navigationController.pushViewController(
            directoryViewerViewController,
            animated: true
        )
    }

    func routeToTextFileViewer(at url: URL) {
        let textViewerInteractor = DebugMenuTextFileViewerInteractor(url: url)
        let textViewerViewController = DebugMenuFileViewerController(title: url.lastPathComponent) {
            self.delegate?.debugMenuDidRequestClosing()
        }
        textViewerViewController.invokeWhenViewIsLoaded {
            textViewerInteractor.start()
        }
        textViewerInteractor.viewController = textViewerViewController

        navigationController.pushViewController(
            textViewerViewController,
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
