import Core
import CoreUI
import Foundation
import UniformTypeIdentifiers
import UIKit

protocol DebugMenuDirectoryViewerInteractor {
    func close()
    func select(item: DirectoryItem)
}

final class DebugMenuDirectoryViewerInteractorImpl: DebugMenuDirectoryViewerInteractor {
    init(
        url: URL,
        delegate: DebugMenuDelegate?
    ) {
        self.url = url
        self.delegate = delegate
    }

    private let url: URL
    private weak var delegate: DebugMenuDelegate?

    weak var router: DebugMenuRouter?
    weak var viewController: DebugMenuDirectoryViewerViewController?

    private let fileManager = FileManager.default

    // MARK: - DebugMenuInteractor

    func start() {
        do {
            let items = try fileManager.contentsOfDirectory(
                at: url, includingPropertiesForKeys: [.isDirectoryKey, .isRegularFileKey],
                options: .empty
            )

            var directoryItems = [DirectoryItem]()
            for item in items {
                if (try item.resourceValues(forKeys: [.isDirectoryKey])).isDirectory == true {
                    directoryItems.append(.directory(item))
                } else if
                    (try item.resourceValues(forKeys: [.isRegularFileKey])).isRegularFile == true,
                    let typeIdentifier = (try item.resourceValues(forKeys: [.typeIdentifierKey])).typeIdentifier
                {
                    if UTType(typeIdentifier)?.conforms(to: .text) == true {
                        directoryItems.append(
                            .file(
                                DirectoryItem.File(
                                    url: item,
                                    type: .text
                                )
                            )
                        )
                    } else if UTType(typeIdentifier)?.conforms(to: .data) == true {
                        if
                            let data = try? Data(contentsOf: item),
                            let _ = UIImage(data: data)
                        {
                            directoryItems.append(
                                .file(
                                    DirectoryItem.File(
                                        url: item,
                                        type: .image
                                    )
                                )
                            )
                        } else {
                            directoryItems.append(
                                .file(
                                    DirectoryItem.File(
                                        url: item,
                                        type: .data
                                    )
                                )
                            )
                        }
                    }
                }
            }

            directoryItems.sort { lhs, rhs in
                switch (lhs, rhs) {
                case let (.directory(lhsURL), .directory(rhsURL)):
                    return lhsURL.lastPathComponent < rhsURL.lastPathComponent

                case let (.file(lhsFile), .file(rhsFile)):
                    return lhsFile.url.lastPathComponent < rhsFile.url.lastPathComponent

                case (.directory, .file):
                    return true

                case (.file, .directory):
                    return false
                }
            }

            viewController?.setItems(directoryItems)
            viewController?.setTitle(url.lastPathComponent)
        } catch {
            safeCrash(error.localizedDescription)
        }
    }

    func close() {
        delegate?.debugMenuDidRequestClosing()
    }

    func select(item: DirectoryItem) {
        switch item {
        case let .directory(url):
            router?.routeToDirectoryViewer(at: url)

        case let .file(file):
            switch file.type {
            case .text:
                router?.routeToTextFileViewer(at: file.url)

            case .image:
                break

            case .data:
                break
            }
        }
    }
}
