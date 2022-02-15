import CoreRIB
import UIKit

private final class DebugMenuViewNavigationController: UINavigationController, PopoverViewControllerCompatible {
    var canCloseAsPopover: Bool { true }
}

protocol DebugMenuRouter: AnyObject { }

final class DebugMenuRouterImpl: Router, DebugMenuRouter {
    init(
        interactor: DebugMenuInteractor,
        viewController: DebugMenuViewController,
        presentationContext: PresentationContext
    ) {
        self.interactor = interactor
        self.viewController = viewController
        self.presentationContext = presentationContext
        super.init(id: DebugMenuRouterIdentifiers.debugMenu)
    }

    private let interactor: DebugMenuInteractor
    private let viewController: DebugMenuViewController
    private let presentationContext: PresentationContext

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
}
