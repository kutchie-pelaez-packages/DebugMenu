import Core
import CoreUI
import Foundation

final class DebugMenuTextFileViewerInteractor {
    init(url: URL) {
        self.url = url
    }

    private let url: URL

    weak var viewController: DebugMenuFileViewerController?

    func start() {
        guard
            let data = try? Data(contentsOf: url),
            let string = String(data: data, encoding: .utf8)
        else {
            return
        }

        viewController?.setContent(
            string.attributed
                .appending(DebugMenuConstants.FileViewer.font, for: .font)
                .appending(DebugMenuConstants.FileViewer.color, for: .foregroundColor)
        )
    }
}
