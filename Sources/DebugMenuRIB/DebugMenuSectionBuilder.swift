import AppearanceStyle
import Core
import CoreUI
import DebugMenuDomains
import Language
import LocalizationManager
import PermissionsManager
import SessionManager
import Tweak
import TweakEmitter

protocol DebugMenuSectionBuilder {
    func build(for onboarding: DebugMenuGeneralDomain.Onboarding?) -> System.TableView.Section?
    func build(for userInterface: DebugMenuGeneralDomain.UserInterface?) -> System.TableView.Section?
    func build(for session: DebugMenuGeneralDomain.Session?) -> System.TableView.Section?
    func build(for localization: DebugMenuGeneralDomain.Localization?) -> System.TableView.Section?
    func build(for permissions: DebugMenuGeneralDomain.Permissions?) -> System.TableView.Section?
    func build(for grid: DebugMenuGridDomain.Grid?) -> System.TableView.Section?
    func build(for safeArea: DebugMenuGridDomain.SafeArea?) -> System.TableView.Section?
    func build(for centringGuides: DebugMenuGridDomain.CentringGuides?) -> System.TableView.Section?
    func buildLoggingSection() -> System.TableView.Section
}

private enum Symbols: SymbolsCollection {
    case checkmarkSealFill
    case iphoneHomebutton
    case moonFill
    case personFillQuestionmark
    case sunMaxFill
    case xmarkOctagonFill
}

struct DebugMenuSectionBuilderImpl: DebugMenuSectionBuilder {
    init(
        interactor: DebugMenuInteractor,
        tweakEmitter: TweakEmitter,
        localizationManager: LocalizationManager
    ) {
        self.interactor = interactor
        self.tweakEmitter = tweakEmitter
        self.localizationManager = localizationManager
    }

    private weak var interactor: DebugMenuInteractor?
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
            ],
            header: System.TableView.SystemHeader(
                text: "ONBOARDING",
                font: System.Fonts.Mono.regular(13)
            )
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
                            Symbols.moonFill.image
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
            ],
            header: System.TableView.SystemHeader(
                text: "USER INTERFACE",
                font: System.Fonts.Mono.regular(13)
            )
        )
    }

    func build(for session: DebugMenuGeneralDomain.Session?) -> System.TableView.Section? {
        guard let session = session else { return nil }

        let currentSessionNumber = session.sessionResolver()

        return System.TableView.Section(
            rows: [
                System.TableView.Row(
                    content: System.TableView.SystemContent(
                        title: System.TableView.SystemContent.Title(
                            text: "Current session: \(currentSessionNumber)",
                            font: System.Fonts.Mono.regular(17)
                        )
                    ),
                    trailingContent: .stepper(
                        value: Double(currentSessionNumber),
                        action: { newValue in
                            let newSessionNumber = Int(newValue)

                            if newSessionNumber > currentSessionNumber {
                                tweakEmitter.emit(
                                    .General.Session.incrementSessionNumber
                                )
                            } else if newSessionNumber < currentSessionNumber {
                                tweakEmitter.emit(
                                    .General.Session.decrementSessionNumber
                                )
                            }
                        }
                    )
                )
            ],
            header: System.TableView.SystemHeader(
                text: "SESSION",
                font: System.Fonts.Mono.regular(13)
            )
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

        return System.TableView.Section(
            rows: rows,
            header: System.TableView.SystemHeader(
                text: "LOCALIZATION",
                font: System.Fonts.Mono.regular(13)
            )
        )
    }

    func build(for permissions: DebugMenuGeneralDomain.Permissions?) -> System.TableView.Section? {
        guard let permissions = permissions else { return nil }

        func title(for domain: PermissionDomain) -> String {
            switch domain {
            case .photoLibrary:
                return "Library"

            case .camera:
                return "Camera"

            case .appTracking:
                return "Tracking"
            }
        }

        func selectedIndex(for domain: PermissionDomain) -> Int {
            guard permissions.isPermissionStatusMockedResolver(domain) else {
                return 0
            }

            let status = permissions.permissionStatusResolver(domain)

            switch status {
            case .notDetermined:
                return 1

            case .restricted:
                return 2

            case .permitted:
                return 3
            }
        }

        return System.TableView.Section(
            rows: PermissionDomain.allCases.map { domain in
                System.TableView.Row(
                    content: System.TableView.SystemContent(
                        title: System.TableView.SystemContent.Title(
                            text: title(for: domain),
                            font: System.Fonts.Mono.regular(17)
                        )
                    ),
                    trailingContent: .segmentedControl(
                        items: [
                            Symbols.iphoneHomebutton.image,
                            Symbols.personFillQuestionmark.image,
                            Symbols.xmarkOctagonFill.image,
                            Symbols.checkmarkSealFill.image
                        ],
                        selectedIndex: selectedIndex(for: domain),
                        action: { selectedIndex in
                            let newValue: PermissionStatus?
                            switch selectedIndex {
                            case 0:
                                newValue = nil

                            case 1:
                                newValue = .notDetermined

                            case 2:
                                newValue = .restricted

                            case 3:
                                newValue = .permitted

                            default:
                                return
                            }

                            tweakEmitter.emit(
                                .General.Permissions.updateAppearanceStyle(
                                    domain: domain,
                                    newValue: newValue
                                )
                            )
                        }
                    )
                )
            },
            header: System.TableView.SystemHeader(
                text: "PERMISSIONS",
                font: System.Fonts.Mono.regular(13)
            )
        )
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
            ],
            header: System.TableView.SystemHeader(
                text: "GRID",
                font: System.Fonts.Mono.regular(13)
            )
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
            ],
            header: System.TableView.SystemHeader(
                text: "SAFE AREA",
                font: System.Fonts.Mono.regular(13)
            )
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
            ],
            header: System.TableView.SystemHeader(
                text: "GUIDES",
                font: System.Fonts.Mono.regular(13)
            )
        )
    }

    func buildLoggingSection() -> System.TableView.Section {
        return System.TableView.Section(
            rows: [
                System.TableView.Row(
                    content: System.TableView.SystemContent(
                        title: System.TableView.SystemContent.Title(
                            text: "View logs",
                            font: System.Fonts.Mono.regular(17),
                            color: System.Colors.Tint.primary
                        )
                    ),
                    action: {
                        interactor?.showLogs()
                    }
                ),
                System.TableView.Row(
                    content: System.TableView.SystemContent(
                        title: System.TableView.SystemContent.Title(
                            text: "Export logs",
                            font: System.Fonts.Mono.regular(17),
                            color: System.Colors.Tint.primary
                        )
                    ),
                    action: {
                        interactor?.exportLogs()
                    }
                )
            ],
            header: System.TableView.SystemHeader(
                text: "LOGGING",
                font: System.Fonts.Mono.regular(13)
            )
        )
    }
}
