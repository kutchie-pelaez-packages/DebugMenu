import Core

struct DebugMenuUpdatePublisherResolverFactory {
    let parent: DebugMenuComp

    func produce() -> Resolver<VoidPublisher> {
        { parent.localizationManager.languageSubject.eraseToVoidPublisher() }
    }
}
