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
                sessionResolver: { parent.sessionManager.sessionValueSubject.value }
            ),
            localization: DebugMenuGeneralDomain.Localization(
                languageResolver: { parent.localizationManager.languageSubject.value }
            ),
            permissions: DebugMenuGeneralDomain.Permissions(
                permissionStatusResolver: { parent.permissionsManager.permissionStatus(for: $0) },
                isPermissionStatusMockedResolver: { parent.permissionsManager.isPermissionStatusMocked(for: $0) }
            )
        )
    }
}
