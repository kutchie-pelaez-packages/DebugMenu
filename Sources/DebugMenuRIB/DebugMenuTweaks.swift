import AppearanceStyle
import DebugGridOverlay
import Language
import Tweak
import Wording

extension Tweak {
    enum General {
        enum Onboarding {
            static func updateIsOnboardingPassed(newValue: Bool) -> Tweak {
                Tweak(
                    id: .Onboarding.updateIsOnboardingPassed,
                    args: [
                        .Common.newValue: newValue
                    ]
                )
            }

            static var startOnboarding: Tweak {
                Tweak(id: .Onboarding.startOnboarding)
            }
        }

        enum UserInterface {
            static func updateAppearanceStyle(newValue: AppearanceStyle) -> Tweak {
                Tweak(
                    id: .Appearance.updateAppearanceStyle,
                    args: [
                        .Common.newValue: newValue
                    ]
                )
            }
        }

        enum Localization {
            static func updateLanguage(newValue: Language) -> Tweak {
                Tweak(
                    id: .Localization.updateLanguage,
                    args: [
                        .Common.newValue: newValue
                    ]
                )
            }

            static var fetchAndUpdateWording: Tweak {
                Tweak(id: .Localization.fetchAndUpdateWording)
            }
        }
    }

    enum Grid {
        static func updateGridVisibility(newValue: Bool) -> Tweak {
            Tweak(
                id: .Grid.updateGridVisibility,
                args: [
                    .Common.newValue: newValue
                ]
            )
        }

        static func updateGridHorizontalSpacing(newValue: Double) -> Tweak {
            Tweak(
                id: .Grid.updateGridHorizontalSpacing,
                args: [
                    .Common.newValue: newValue
                ]
            )
        }

        static func updateGridVerticalSpacing(newValue: Double) -> Tweak {
            Tweak(
                id: .Grid.updateGridVerticalSpacing,
                args: [
                    .Common.newValue: newValue
                ]
            )
        }
        
        static func updateSafeAreaVisibility(newValue: Bool) -> Tweak {
            Tweak(
                id: .Grid.updateSafeAreaVisibility,
                args: [
                    .Common.newValue: newValue
                ]
            )
        }

        static func updateCentringGuidesVisibility(newValue: Bool) -> Tweak {
            Tweak(
                id: .Grid.updateCentringGuidesVisibility,
                args: [
                    .Common.newValue: newValue
                ]
            )
        }
    }
}

extension Tweak.ID {
    public enum Onboarding {
        public static var updateIsOnboardingPassed = Tweak.ID()
        public static var startOnboarding = Tweak.ID()
    }
}
