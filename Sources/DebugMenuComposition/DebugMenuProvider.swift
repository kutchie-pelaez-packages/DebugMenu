import Core
import CoreRIB
import UIKit

public protocol DebugMenuProvider {
    var isOnboardingPassedResolver: Resolver<Bool> { get }
    var routerResolver: Resolver<Routable> { get }
    var windowResolver: Resolver<UIWindow> { get }
}
