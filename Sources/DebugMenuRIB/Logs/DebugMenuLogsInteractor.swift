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

    func start() {
        guard
            let logsData = try? logsExtractor.extract(),
            let logsString = String(data: logsData, encoding: .utf8)
        else {
            return
        }

        viewController?.setLogs(logsString)
    }

    func close() {
        delegate?.debugMenuDidRequestClosing()
    }
}
