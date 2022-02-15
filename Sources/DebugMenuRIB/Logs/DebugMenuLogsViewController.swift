import Core
import CoreUI
import CoreRIB
import UIKit

private let font = System.Fonts.Mono.regular(10)

protocol DebugMenuLogsViewController: ViewController {
    func setLogs(_ logsString: String)
}

final class DebugMenuLogsViewControllerImpl: ViewController, DebugMenuLogsViewController {
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

    override func configureViews() {
        view.backgroundColor = System.Colors.Background.primary

        scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(
            horizontal: 16,
            vertical: 24
        )
        view.addSubviews(scrollView)

        contentView = UIView()
        scrollView.addSubviews(contentView)

        label = UILabel(
            font: font,
            textColor: System.Colors.Label.secondary,
            numberOfLines: 0
        )
        contentView.addSubviews(label)
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

    override func viewDidLayout() {
        scrollView.contentSize = label.text.orEmpty.size(font: font)
    }

    // MARK: - DebugMenuLogsViewController

    func setLogs(_ logsString: String) {
        label.text = logsString
    }
}
