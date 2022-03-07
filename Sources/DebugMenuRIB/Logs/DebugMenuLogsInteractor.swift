import Core
import CoreUI
import Foundation
import LogsExtractor
import UIKit

protocol DebugMenuLogsInteractor { }

final class DebugMenuLogsInteractorImpl: DebugMenuLogsInteractor {
    init(logsExtractor: LogsExtractor) {
        self.logsExtractor = logsExtractor
    }

    private let logsExtractor: LogsExtractor

    weak var viewController: DebugMenuFileViewerController?

    func start() {
        guard
            let logsData = try? logsExtractor.extract(),
            let logsString = String(data: logsData, encoding: .utf8)
        else {
            return
        }

        let result = NSMutableAttributedString()

        let lines = logsString.split(
            separator: "\n",
            omittingEmptySubsequences: false
        )

        for line in lines {
            let backgroundColor: UIColor
            if line.contains("🔴") {
                backgroundColor = DebugMenuConstants.LogsViewer.Colors.error
            } else if line.contains("🟡") {
                backgroundColor = DebugMenuConstants.LogsViewer.Colors.warning
            } else {
                backgroundColor = .clear
            }

            let replacedline = line
                .replacingOccurrences(
                    of: "🔴 ",
                    with: ""
                )
                .replacingOccurrences(
                    of: "🟡 ",
                    with: ""
                ) + "\n"

            result.append(
                NSAttributedString(
                    string: replacedline,
                    attributes: [
                        .font: DebugMenuConstants.FileViewer.font,
                        .foregroundColor: DebugMenuConstants.FileViewer.color,
                        .backgroundColor: backgroundColor
                    ]
                )
            )
        }

        viewController?.setContent(result)
    }
}
