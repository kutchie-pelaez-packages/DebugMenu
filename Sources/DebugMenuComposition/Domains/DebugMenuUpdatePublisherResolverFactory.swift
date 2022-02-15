import Combine
import Core

struct DebugMenuUpdatePublisherResolverFactory {
    let parent: DebugMenuComp

    func produce() -> Resolver<VoidPublisher> {
        {
            Publishers.Merge(
                parent.localizationManager.languageSubject.eraseToVoidPublisher(),
                parent.sessionManager.sessionValueSubject.eraseToVoidPublisher()
            ).eraseToVoidPublisher()
        }
    }
}
