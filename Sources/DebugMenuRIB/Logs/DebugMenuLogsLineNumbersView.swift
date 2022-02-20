import CoreUI
import UIKit

final class DebugMenuLogsLineNumbersView: View {
    static let leftInset: Double = 6
    static let rightInset: Double = 6

    private var backgroundView: UIView!
    private var label: UILabel!

    override func configureViews() {
        clipsToBounds = false

        backgroundView = UIView()
        backgroundView.backgroundColor = System.Colors.Background.primary
        addSubviews(backgroundView)

        label = UILabel(
            font: DebugMenuLogsViewControllerImpl.font,
            textColor: System.Colors.Label.tertiary,
            numberOfLines: 0,
            textAlignment: .right
        )
        addSubviews(label)
    }

    override func constraintViews() {
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(-2000)
        }

        label.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(Self.leftInset)
            make.right.equalToSuperview().inset(Self.rightInset)
            make.top.equalToSuperview().inset(-6)
            make.bottom.equalToSuperview().inset(6)
        }
    }

    var prefferedWidth: Double {
        let textWidth = "\(numberOfLines)".size(
            font: DebugMenuLogsViewControllerImpl.font
        ).width

        return Self.leftInset + textWidth + Self.rightInset
    }

    // MARK: -

    var numberOfLines: Int = 0 {
        didSet {
            label.text = (1...numberOfLines)
                .map(String.init)
                .joined(separator: "\n")
        }
    }
}
