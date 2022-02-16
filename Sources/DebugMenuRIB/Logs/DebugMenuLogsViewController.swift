import Core
import CoreUI
import CoreRIB
import UIKit

protocol DebugMenuLogsViewController: ViewController {
    func setLogs(_ logsString: NSAttributedString)
}

final class DebugMenuLogsViewControllerImpl: ViewController, DebugMenuLogsViewController, UIScrollViewDelegate {
    static let font = System.Fonts.Mono.regular(10)

    init(interactor: DebugMenuLogsInteractor) {
        self.interactor = interactor
        super.init()
    }

    private let interactor: DebugMenuLogsInteractor

    @objc private func handleCloseButton() {
        interactor.close()
    }

    // MARK: - UI

    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var label: UILabel!
    private var numbersView: DebugMenuLogsLineNumbersView!

    override func configureViews() {
        view.backgroundColor = System.Colors.Background.primary

        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        view.addSubviews(scrollView)

        contentView = UIView()
        scrollView.addSubviews(contentView)

        label = UILabel(numberOfLines: 0)
        contentView.addSubviews(label)

        numbersView = DebugMenuLogsLineNumbersView()
        view.addSubviews(numbersView)
    }

    override func configureNavigationBar() {
        navigationItem.title =  "Logs"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(handleCloseButton)
        )
    }

    override func constraintViews() {
        scrollView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.left.top.equalToSuperview()
        }

        label.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }

    // MARK: - DebugMenuLogsViewController

    func setLogs(_ logsAttributedString: NSAttributedString) {
        let stringSize = logsAttributedString.size()

        label.attributedText = logsAttributedString
        scrollView.contentSize = stringSize
        numbersView.numberOfLines = logsAttributedString.string.filter { $0 == "\n" }.count
        numbersView.frame.size = CGSize(
            width: numbersView.prefferedWidth,
            height: scrollView.contentSize.height
        )
        scrollView.contentInset = UIEdgeInsets(
            left: numbersView.prefferedWidth
        )
        scrollView.contentOffset = CGPoint(
            x: -numbersView.prefferedWidth,
            y: scrollView.contentSize.height
        )
    }

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        numbersView.frame = CGRect(
            x: 0,
            y: -scrollView.contentOffset.y,
            width: numbersView.frame.width,
            height: numbersView.frame.height
        )
    }
}
