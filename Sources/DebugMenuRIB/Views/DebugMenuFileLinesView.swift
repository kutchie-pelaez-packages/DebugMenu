import CoreUI
import UIKit

final class DebugMenuFileLinesView: View {

    private var backgroundView: UIView!
    private var label: UILabel!

    override func configureViews() {
        clipsToBounds = false

        backgroundView = UIView()
        backgroundView.backgroundColor = System.Colors.Background.primary
        addSubviews(backgroundView)

        label = UILabel(
            font: DebugMenuConstants.FileViewer.font,
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
            make.left.equalToSuperview().inset(DebugMenuConstants.FileViewer.Lines.leftInset)
            make.right.equalToSuperview().inset(DebugMenuConstants.FileViewer.Lines.rightInset)
            make.top.equalToSuperview().inset(-6)
            make.bottom.equalToSuperview().inset(6)
        }
    }

    var prefferedWidth: Double {
        let textWidth = "\(numberOfLines)".size(
            font: DebugMenuConstants.FileViewer.font
        ).width

        return DebugMenuConstants.FileViewer.Lines.leftInset + textWidth + DebugMenuConstants.FileViewer.Lines.rightInset
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
