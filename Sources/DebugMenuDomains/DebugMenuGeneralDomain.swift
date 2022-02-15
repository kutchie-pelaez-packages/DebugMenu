import AppearanceStyle
import Core
import Language

public struct DebugMenuGeneralDomain {
    public init(
        onboarding: Onboarding?,
        userInterface: UserInterface?,
        session: Session?,
        localization: Localization?
    ) {
        self.onboarding = onboarding
        self.userInterface = userInterface
        self.session = session
        self.localization = localization
    }

    public let onboarding: Onboarding?
    public let userInterface: UserInterface?
    public let session: Session?
    public let localization: Localization?

    public struct Onboarding {
        public init(isOnboardingPassedResolver: @escaping BoolResolver) {
            self.isOnboardingPassedResolver = isOnboardingPassedResolver
        }

        public let isOnboardingPassedResolver: BoolResolver
    }

    public struct UserInterface {
        public init(appearanceStyleResolver: @escaping Resolver<AppearanceStyle>) {
            self.appearanceStyleResolver = appearanceStyleResolver
        }

        public let appearanceStyleResolver: Resolver<AppearanceStyle>
    }

    public struct Session {
        public init(sessionResolver: @escaping IntResolver) {
            self.sessionResolver = sessionResolver
        }

        public let sessionResolver: IntResolver
    }

    public struct Localization {
        public init(languageResolver: @escaping Resolver<Language>) {
            self.languageResolver = languageResolver
        }

        public let languageResolver: Resolver<Language>
    }
}
