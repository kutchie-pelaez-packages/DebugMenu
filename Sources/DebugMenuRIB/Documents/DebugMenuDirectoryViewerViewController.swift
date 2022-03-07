import CoreUI
import UIKit

enum DirectoryItem {
    case directory(URL)
    case file(File)

    struct File {
        let url: URL
        let type: FileType

        enum FileType {
            case data
            case image
            case text
        }
    }
}

private enum Symbols: SymbolsCollection {
    case doc
    case docText
    case folder
    case questionmark
}

protocol DebugMenuDirectoryViewerViewController: ViewController {
    func setTitle(_ title: String)
    func setItems(_ items: [DirectoryItem])
}

final class DebugMenuDirectoryViewerViewControllerImpl: ViewController, DebugMenuDirectoryViewerViewController {
    init(interactor: DebugMenuDirectoryViewerInteractor) {
        self.interactor = interactor
        super.init()
    }

    private let interactor: DebugMenuDirectoryViewerInteractor

    // MARK: -

    @objc private func handleCloseButton() {
        interactor.close()
    }

    private func row(from item: DirectoryItem) -> System.TableView.Row {
        System.TableView.Row(
            content: System.TableView.SystemContent(
                title: System.TableView.SystemContent.Title(
                    text: title(for: item),
                    font: System.Fonts.Mono.regular(17)
                ),
                subtitle: subtitle(for: item)
            ),
            leadingContent: leadingContent(for: item),
            trailingContent: trailingContent(for: item),
            action: { [weak self] in
                self?.interactor.select(item: item)
            }
        )
    }

    private func title(for item: DirectoryItem) -> String {
        switch item {
        case let .directory(url):
            return url.lastPathComponent

        case let .file(file):
            return file.url.lastPathComponent
        }
    }

    private func subtitle(for item: DirectoryItem) -> System.TableView.SystemContent.Subtitle? {
        let text: String?
        switch item {
        case let .directory(url):
            if let items = try? FileManager.default.contentsOfDirectory(
                at: url, includingPropertiesForKeys: [.isDirectoryKey, .isRegularFileKey],
                options: .empty
            ) {
                let count = items.count
                text = "\(count) \(count == 1 ? "item" : "items")"
            } else {
                text = nil
            }

        case let .file(file):
            if
                let attributes = try? FileManager.default.attributesOfItem(atPath: file.url.path),
                let size = attributes[.size] as? UInt64
            {
                text = "\(size) Bytes"
            } else {
                text = nil
            }
        }

        guard let text = text else { return nil }

        return System.TableView.SystemContent.Subtitle(text: text)
    }

    private func leadingContent(for item: DirectoryItem) -> System.TableView.SystemLeadingContent {
        switch item {
        case .directory:
            return .image(Symbols.folder.image)

        case let .file(file):
            switch file.type {
            case .text:
                return .image(Symbols.docText.image)

            case .image:
                if
                    let imageData = try? Data(contentsOf: file.url),
                    let image = UIImage(data: imageData)
                {
                    return .image(
                        System.TableView.SystemLeadingContent.Image(
                            image,
                            corners: .rounded(8),
                            maximumSize: CGSize(100)
                        )
                    )
                } else {
                    return .image(Symbols.questionmark.image)
                }

            case .data:
                return .image(Symbols.doc.image)
            }
        }
    }

    private func trailingContent(for item: DirectoryItem) -> System.TableView.SystemTrailingContent? {
        switch item {
        case .directory:
            return .disclosureIndicator

        case let .file(file):
            switch file.type {
            case .text:
                return .disclosureIndicator

            case .image:
                return nil

            case .data:
                return nil
            }
        }
    }

    // MARK: - UI

    private var tableView: System.TableView!

    override func configureViews() {
        tableView = System.TableView()
        view.addSubviews(tableView)
    }

    override func constraintViews() {
        tableView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }

    override func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(handleCloseButton)
        )
    }

    // MARK: - DebugMenuDirectoryViewerViewController

    func setTitle(_ title: String) {
        navigationItem.title = title
    }

    func setItems(_ items: [DirectoryItem]) {
        tableView.state = System.TableView.State(
            sections: [
                System.TableView.Section(rows: items.map(row))
            ]
        )
    }
}
