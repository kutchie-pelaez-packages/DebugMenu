import CoreUI
import UIKit

private let dimension: Double = 64

private enum Symbols: SymbolsCollection {
    case hammerFill
}

final class DebugMenuButton: Button {
    func fadeIn() {
        animation(
            duration: .milliseconds(25),
            animations: {
                self.alpha = 1
            }
        )
    }

    func fadeOut(animated: Bool) {
        animation(
            duration: .milliseconds(400),
            animated: animated,
            animations: {
                self.alpha = 0.1
            }
        )
    }

    // MARK: - UI

    override func preSetup() {
        fadeOut(animated: false)
    }

    override func makeConfiguration() -> UIButton.Configuration? {
        var configuration = Configuration.plain()
        configuration.image = Symbols
            .hammerFill
            .font(System.Fonts.medium(20))
            .monochrome(System.Colors.Tint.white)
            .image
        configuration.background.backgroundColor = System.Colors.Tint.primary
        configuration.cornerStyle = .capsule

        return configuration
    }

    override var intrinsicContentSize: CGSize {
        CGSize(dimension)
    }
}
