import Core
import CoreUI
import Foundation
import LogsExtractor
import UIKit

protocol DebugMenuLogsInteractor {
    func close()
}

final class DebugMenuLogsInteractorImpl: DebugMenuLogsInteractor {
    init(
        logsExtractor: LogsExtractor,
        delegate: DebugMenuDelegate?
    ) {
        self.logsExtractor = logsExtractor
        self.delegate = delegate
    }

    private let logsExtractor: LogsExtractor
    private weak var delegate: DebugMenuDelegate?

    weak var viewController: DebugMenuLogsViewController?

    // MARK: - DebugMenuInteractor

    // yellow:
    // red:

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
                backgroundColor = UIColor(hex: 0xF9D5D256)
            } else if line.contains("🟡") {
                backgroundColor = UIColor(hex: 0xFFF3CB59)
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
                        .font: DebugMenuLogsViewControllerImpl.font,
                        .foregroundColor: System.Colors.Label.primary,
                        .backgroundColor: backgroundColor
                    ]
                )
            )
        }

        viewController?.setLogs(result)
    }

    func close() {
        delegate?.debugMenuDidRequestClosing()
    }
}
