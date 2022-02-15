import AppearanceStyle
import Core
import CoreUI
import DebugMenuDomains
import Language
import LocalizationManager
import Tweak
import TweakEmitter

protocol DebugMenuSectionBuilder {
    func build(for onboarding: DebugMenuGeneralDomain.Onboarding?) -> System.TableView.Section?
    func build(for userInterface: DebugMenuGeneralDomain.UserInterface?) -> System.TableView.Section?
    func build(for localization: DebugMenuGeneralDomain.Localization?) -> System.TableView.Section?
    func build(for grid: DebugMenuGridDomain.Grid?) -> System.TableView.Section?
    func build(for safeArea: DebugMenuGridDomain.SafeArea?) -> System.TableView.Section?
    func build(for centringGuides: DebugMenuGridDomain.CentringGuides?) -> System.TableView.Section?
}

private enum Symbols: SymbolsCollection {
    case iphoneHomebutton
    case sunMaxFill
    case moonFill
}

struct DebugMenuSectionBuilderImpl: DebugMenuSectionBuilder {
    init(
        tweakEmitter: TweakEmitter,
        localizationManager: LocalizationManager
    ) {
        self.tweakEmitter = tweakEmitter
        self.localizationManager = localizationManager
    }

    private let tweakEmitter: TweakEmitter
    private let localizationManager: LocalizationManager

    // MARK: - DebugMenuSectionBuilder

    func build(for onboarding: DebugMenuGeneralDomain.Onboarding?) -> System.TableView.Section? {
        guard let onboarding = onboarding else { return nil }

        return System.TableView.Section(
            rows: [
                System.TableView.Row(
                    content: System.TableView.SystemContent(
                        title: System.TableView.SystemContent.Title(
                            text: "Is onboarding passed",
                            font: System.Fonts.Mono.regular(17)
                        )
                    ),
                    trailingContent: .switch(
                        enabled: onboarding.isOnboardingPassedResolver(),
                        action: { enabled in
                            tweakEmitter.emit(
                                .General.Onboarding.updateIsOnboardingPassed(
                                    newValue: enabled
                                )
                            )
                        }
                    )
                ),
                System.TableView.Row(
                    content: System.TableView.SystemContent(
                        title: System.TableView.SystemContent.Title(
                            text: "Start onboarding",
                            font: System.Fonts.Mono.regular(17),
                            color: System.Colors.Tint.primary
                        )
                    ),
                    action: {
                        tweakEmitter.emit(
                            .General.Onboarding.startOnboarding
                        )
                    }
                )
            ]
        )
    }

    func build(for userInterface: DebugMenuGeneralDomain.UserInterface?) -> System.TableView.Section? {
        guard let userInterface = userInterface else { return nil }

        let resolvedAppearanceStyle = userInterface.appearanceStyleResolver()

        let currentStyleSelectedIndex: Int
        switch resolvedAppearanceStyle {
        case .system:
            currentStyleSelectedIndex = 0

        case let .custom(theme):
            switch theme {
            case .light:
                currentStyleSelectedIndex = 1

            case .dark:
                currentStyleSelectedIndex = 2
            }
        }

        return System.TableView.Section(
            rows: [
                System.TableView.Row(
                    content: System.TableView.SystemContent(
                        title: System.TableView.SystemContent.Title(
                            text: "User interface style",
                            font: System.Fonts.Mono.regular(17)
                        )
                    ),
                    trailingContent: .segmentedControl(
                        items: [
                            Symbols.iphoneHomebutton.image,
                            Symbols.sunMaxFill.image,
                            Symbols.moonFill.image,
                        ],
                        selectedIndex: currentStyleSelectedIndex,
                        action: { selectedIndex in
                            let newAppearanceStyle: AppearanceStyle
                            switch selectedIndex {
                            case 0:
                                newAppearanceStyle = .system

                            case 1:
                                newAppearanceStyle = .custom(.light)

                            case 2:
                                newAppearanceStyle = .custom(.dark)

                            default:
                                return
                            }

                            tweakEmitter.emit(
                                .General.UserInterface.updateAppearanceStyle(
                                    newValue: newAppearanceStyle
                                )
                            )
                        }
                    )
                )
            ]
        )
    }

    func build(for localization: DebugMenuGeneralDomain.Localization?) -> System.TableView.Section? {
        guard let localization = localization else { return nil }

        let resolvedLanguage = localization.languageResolver()

        var rows = [
            System.TableView.Row(
                content: System.TableView.SystemContent(
                    title: System.TableView.SystemContent.Title(
                        text: "system(\(Localization.system(for: localizationManager.supportedLocalizations)))",
                        font: System.Fonts.Mono.regular(17)
                    )
                ),
                trailingContent: resolvedLanguage.isSystem ? .checkmark : nil,
                action: {
                    tweakEmitter.emit(
                        .General.Localization.updateLanguage(
                            newValue: .system(
                                .system(
                                    for: localizationManager.supportedLocalizations
                                )
                            )
                        )
                    )
                }
            )
        ]
        for localization in localizationManager.supportedLocalizations.englishFirst {
            rows.append(
                System.TableView.Row(
                    content: System.TableView.SystemContent(
                        title: System.TableView.SystemContent.Title(
                            text: localization.localizedName.lowercased(),
                            font: System.Fonts.Mono.regular(17)
                        )
                    ),
                    trailingContent: resolvedLanguage.isCustom(localization) ? .checkmark : nil,
                    action: {
                        tweakEmitter.emit(
                            .General.Localization.updateLanguage(
                                newValue: .custom(localization)
                            )
                        )
                    }
                )
            )
        }
        rows.append(
            System.TableView.Row(
                content: System.TableView.SystemContent(
                    title: System.TableView.SystemContent.Title(
                        text: "Force wording fetch",
                        font: System.Fonts.Mono.regular(17),
                        color: System.Colors.Tint.primary
                    )
                ),
                action: {
                    tweakEmitter.emit(
                        .General.Localization.fetchAndUpdateWording
                    )
                }
            )
        )

        return System.TableView.Section(rows: rows)
    }

    func build(for grid: DebugMenuGridDomain.Grid?) -> System.TableView.Section? {
        guard let grid = grid else { return nil }

        return System.TableView.Section(
            rows: [
                System.TableView.Row(
                    content: System.TableView.SystemContent(
                        title: System.TableView.SystemContent.Title(
                            text: "Grid visible",
                            font: System.Fonts.Mono.regular(17)
                        )
                    ),
                    trailingContent: .switch(
                        enabled: grid.isVisibleResolver(),
                        action: { enabled in
                            tweakEmitter.emit(
                                .Grid.updateGridVisibility(
                                    newValue: enabled
                                )
                            )
                        }
                    )
                ),
                System.TableView.Row(
                    content: System.TableView.SystemContent(
                        title: System.TableView.SystemContent.Title(
                            text: "Horizontal spacing",
                            font: System.Fonts.Mono.regular(17)
                        )
                    ),
                    trailingContent: .stepper(
                        value: grid.horizontalSpacingResolver(),
                        action: { newValue in
                            tweakEmitter.emit(
                                .Grid.updateGridHorizontalSpacing(
                                    newValue: newValue
                                )
                            )
                        }
                    )
                ),
                System.TableView.Row(
                    content: System.TableView.SystemContent(
                        title: System.TableView.SystemContent.Title(
                            text: "Vertical spacing",
                            font: System.Fonts.Mono.regular(17)
                        )
                    ),
                    trailingContent: .stepper(
                        value: grid.verticalSpacingResolver(),
                        action: { newValue in
                            tweakEmitter.emit(
                                .Grid.updateGridVerticalSpacing(
                                    newValue: newValue
                                )
                            )
                        }
                    )
                )
            ]
        )
    }

    func build(for safeArea: DebugMenuGridDomain.SafeArea?) -> System.TableView.Section? {
        guard let safeArea = safeArea else { return nil }

        return System.TableView.Section(
            rows: [
                System.TableView.Row(
                    content: System.TableView.SystemContent(
                        title: System.TableView.SystemContent.Title(
                            text: "Safe area visible",
                            font: System.Fonts.Mono.regular(17)
                        )
                    ),
                    trailingContent: .switch(
                        enabled: safeArea.isVisibleResolver(),
                        action: { enabled in
                            tweakEmitter.emit(
                                .Grid.updateSafeAreaVisibility(
                                    newValue: enabled
                                )
                            )
                        }
                    )
                )
            ]
        )
    }

    func build(for centringGuides: DebugMenuGridDomain.CentringGuides?) -> System.TableView.Section? {
        guard let centringGuides = centringGuides else { return nil }

        return System.TableView.Section(
            rows: [
                System.TableView.Row(
                    content: System.TableView.SystemContent(
                        title: System.TableView.SystemContent.Title(
                            text: "Centring guides visible",
                            font: System.Fonts.Mono.regular(17)
                        )
                    ),
                    trailingContent: .switch(
                        enabled: centringGuides.isVisibleResolver(),
                        action: { enabled in
                            tweakEmitter.emit(
                                .Grid.updateCentringGuidesVisibility(
                                    newValue: enabled
                                )
                            )
                        }
                    )
                )
            ]
        )
    }
}