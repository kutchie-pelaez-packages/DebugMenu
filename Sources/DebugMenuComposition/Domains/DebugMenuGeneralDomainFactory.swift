import DebugMenuDomains

struct DebugMenuGeneralDomainFactory {
    let parent: DebugMenuComp

    func produce() -> DebugMenuGeneralDomain {
        DebugMenuGeneralDomain(
            onboarding: DebugMenuGeneralDomain.Onboarding(
                isOnboardingPassedResolver: parent.provider.isOnboardingPassedResolver
            ),
            userInterface: DebugMenuGeneralDomain.UserInterface(
                appearanceStyleResolver: { parent.appearanceManager.appearanceStyleSubject.value }
            ),
            session: DebugMenuGeneralDomain.Session(
                sessionResolver: { parent.sessionManager.session }
            ),
            localization: DebugMenuGeneralDomain.Localization(
                languageResolver: { parent.localizationManager.languageSubject.value }
            )
        )
    }
}
