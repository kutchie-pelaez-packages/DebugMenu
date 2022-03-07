import Core
import CoreUI
import UIKit

final class DebugMenuFileViewerController: ViewController, UIScrollViewDelegate {
    init(
        title: String,
        closeBlock: @escaping Block
    ) {
        self._title = title
        self.closeBlock = closeBlock
        super.init()
    }

    private let _title: String
    private let closeBlock: Block

    // MARK: -

    func setContent(_ content: NSAttributedString) {
        let stringSize = content.size()

        label.attributedText = content
        scrollView.contentSize = stringSize
        linesView.numberOfLines = content.string.filter { $0 == "\n" }.count
        linesView.frame.size = CGSize(
            width: linesView.prefferedWidth,
            height: scrollView.contentSize.height
        )
        scrollView.contentInset = UIEdgeInsets(
            left: linesView.prefferedWidth
        )
        scrollView.contentOffset = CGPoint(
            x: -linesView.prefferedWidth,
            y: scrollView.contentSize.height
        )
    }

    @objc private func handleCloseButton() {
        closeBlock()
    }

    // MARK: - UI

    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var label: UILabel!
    private var linesView: DebugMenuFileLinesView!

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

        linesView = DebugMenuFileLinesView()
        view.addSubviews(linesView)
    }

    override func configureNavigationBar() {
        navigationItem.title = _title
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

    // MARK: - UIScrollViewDelegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        linesView.frame = CGRect(
            x: 0,
            y: -scrollView.contentOffset.y,
            width: linesView.frame.width,
            height: linesView.frame.height
        )
    }
}
