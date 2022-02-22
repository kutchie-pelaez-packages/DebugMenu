import AppearanceStyle
import DebugGridOverlay
import Language
import SessionManager
import Tweak
import Wording

extension Tweak {
    enum General {
        enum Onboarding {
            static func updateIsOnboardingPassed(newValue: Bool) -> Tweak {
                Tweak(
                    id: .Onboarding.updateIsOnboardingPassed,
                    args: [
                        .newValue: newValue
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
                        .newValue: newValue
                    ]
                )
            }
        }

        enum Localization {
            static func updateLanguage(newValue: Language) -> Tweak {
                Tweak(
                    id: .Localization.updateLanguage,
                    args: [
                        .newValue: newValue
                    ]
                )
            }

            static var fetchAndUpdateWording: Tweak {
                Tweak(id: .Localization.fetchAndUpdateWording)
            }
        }

        enum Session {
            static var incrementSessionNumber: Tweak {
                Tweak(id: .Session.incrementSessionNumber)
            }
            
            static var decrementSessionNumber: Tweak {
                Tweak(id: .Session.decrementSessionNumber)
            }
        }
    }

    enum Grid {
        static func updateGridVisibility(newValue: Bool) -> Tweak {
            Tweak(
                id: .Grid.updateGridVisibility,
                args: [
                    .newValue: newValue
                ]
            )
        }

        static func updateGridHorizontalSpacing(newValue: Double) -> Tweak {
            Tweak(
                id: .Grid.updateGridHorizontalSpacing,
                args: [
                    .newValue: newValue
                ]
            )
        }

        static func updateGridVerticalSpacing(newValue: Double) -> Tweak {
            Tweak(
                id: .Grid.updateGridVerticalSpacing,
                args: [
                    .newValue: newValue
                ]
            )
        }
        
        static func updateSafeAreaVisibility(newValue: Bool) -> Tweak {
            Tweak(
                id: .Grid.updateSafeAreaVisibility,
                args: [
                    .newValue: newValue
                ]
            )
        }

        static func updateCentringGuidesVisibility(newValue: Bool) -> Tweak {
            Tweak(
                id: .Grid.updateCentringGuidesVisibility,
                args: [
                    .newValue: newValue
                ]
            )
        }
    }
}

extension TweakID {
    public enum Onboarding {
        public static var updateIsOnboardingPassed: TweakID { TweakID() }
        public static var startOnboarding: TweakID { TweakID() }
    }
}
