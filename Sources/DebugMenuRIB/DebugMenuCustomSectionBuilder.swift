import AppearanceStyle
import Core
import CoreUI
import DebugMenuDomains
import Language
import LocalizationManager
import SessionManager
import Tweak
import TweakEmitter
import UIKit

protocol DebugMenuCustomSectionBuilder {
    func build(for section: DebugMenuCustomDomain.Section) -> System.TableView.Section
}

struct DebugMenuCustomSectionBuilderImpl: DebugMenuCustomSectionBuilder {
    init(
        tweakEmitter: TweakEmitter
    ) {
        self.tweakEmitter = tweakEmitter
    }

    private let tweakEmitter: TweakEmitter

    private func row(for item: DebugMenuCustomDomain.Item) -> System.TableView.Row {
        System.TableView.Row(
            content: System.TableView.SystemContent(
                title: System.TableView.SystemContent.Title(
                    text: contentText(for: item),
                    font: System.Fonts.Mono.regular(17),
                    color: contentColor(for: item)
                )
            ),
            trailingContent: trailingContent(for: item),
            action: action(for: item)
        )
    }

    private func contentText(for item: DebugMenuCustomDomain.Item) -> String {
        switch item {
        case let .button(text, _):
            return text()

        case let .selectingButton(text, _, _):
            return text()

        case let .switch(text, _, _):
            return text()

        case let .stepper(text, _, _):
            return text()

        case let .segments(text, _, _, _):
            return text()
        }
    }

    private func contentColor(for item: DebugMenuCustomDomain.Item) -> UIColor {
        switch item {
        case .selectingButton, .switch, .stepper, .segments:
            return System.Colors.Label.primary

        case .button:
            return System.Colors.Tint.primary
        }
    }

    private func trailingContent(for item: DebugMenuCustomDomain.Item) -> System.TableView.SystemTrailingContent? {
        switch item {
        case .button:
            return nil

        case let .selectingButton(_, isSelected, _):
            return isSelected() ? .checkmark : nil

        case let .switch(_, enabled, tweak):
            return .switch(
                enabled: enabled(),
                action: { enabled in
                    tweakEmitter.emit(tweak(enabled))
                }
            )

        case let .stepper(_, value, tweak):
            return .stepper(
                value: value(),
                action: { value in
                    tweakEmitter.emit(tweak(value))
                }
            )

        case let .segments(_, items, selectedIndex, tweak):
            return .segmentedControl(
                items: items(),
                selectedIndex: selectedIndex(),
                action: { selectedIndex in
                    tweakEmitter.emit(tweak(selectedIndex))
                }
            )
        }
    }

    private func action(for item: DebugMenuCustomDomain.Item) -> Block? {
        switch item {
        case let .button(_, tweak):
            return {
                tweakEmitter.emit(tweak(()))
            }

        case let .selectingButton(_, _, tweak):
            return {
                tweakEmitter.emit(tweak(()))
            }

        case .switch, .stepper, .segments:
            return nil
        }
    }

    // MARK: - DebugMenuCustomSectionBuilder

    func build(for section: DebugMenuCustomDomain.Section) -> System.TableView.Section {
        let header = section.title.isNotNil ? System.TableView.SystemHeader(
            text: section.title!,
            font: System.Fonts.Mono.regular(13)
        ) : nil

        return System.TableView.Section(
            rows: section.items.map(row),
            header: header
        )
    }
}
