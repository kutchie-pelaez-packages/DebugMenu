import Combine
import Core
import CoreUI
import DebugMenuDomains
import Foundation
import LogsExtractor

protocol DebugMenuInteractor: AnyObject {
    func close()
    func selectDomain(at index: Int)
    func showLogs()
    func exportLogs()
    func showDocuments()
}

final class DebugMenuInteractorImpl: DebugMenuInteractor {
    init(
        domains: DebugMenuDomains,
        logsExtractor: LogsExtractor,
        delegate: DebugMenuDelegate
    ) {
        self.domains = domains
        self.logsExtractor = logsExtractor
        self.delegate = delegate
        subscribeToEvents()
    }

    private let domains: DebugMenuDomains
    private let logsExtractor: LogsExtractor
    private weak var delegate: DebugMenuDelegate?

    weak var router: DebugMenuRouter?
    weak var viewController: DebugMenuViewController?

    var sectionBuilder: DebugMenuSectionBuilder?
    var customSectionBuilder: DebugMenuCustomSectionBuilder?

    private var cancellables = [AnyCancellable]()
    private var selectedDomainIndex: Int = 0 {
        didSet {
            guard selectedDomainIndex != oldValue else { return }

            syncState()
        }
    }

    // MARK: -

    private func subscribeToEvents() {
        domains.updatePublisherResolver()
            .sink { [weak self] in
                self?.syncState()
            }
            .store(in: &cancellables)
    }

    private func syncState() {
        let sections: [System.TableView.Section]
        switch selectedDomainIndex {
        case 0:
            sections = makeGeneralSections()

        case 1:
            sections = makeGridSections()

        default:
            guard let customDomain = domains.customDomains?[safe: selectedDomainIndex - 2] else {
                safeCrash()
                sections = []
                break
            }

            sections = makeCustomSections(for: customDomain)
        }

        let customDomainTitles = domains.customDomains?.map {
            $0.title
        } ?? []

        viewController?.state = System.TableView.State(
            sections: sections
        )
        viewController?.setDomains(
            [
                domains.generalDomain.isNotNil ? "General" : nil,
                domains.gridDomain.isNotNil ? "Grid" : nil,
            ].unwrapped() + customDomainTitles
        )
    }

    private func makeGeneralSections() -> [System.TableView.Section] {
        [
            sectionBuilder?.build(for: domains.generalDomain?.localization),
            sectionBuilder?.build(for: domains.generalDomain?.userInterface),
            sectionBuilder?.build(for: domains.generalDomain?.session),
            sectionBuilder?.buildFilesSection(),
            sectionBuilder?.build(for: domains.generalDomain?.onboarding),
            sectionBuilder?.buildLoggingSection(),
            sectionBuilder?.build(for: domains.generalDomain?.permissions)
        ].unwrapped()
    }

    private func makeGridSections() -> [System.TableView.Section] {
        [
            sectionBuilder?.build(for: domains.gridDomain?.grid),
            sectionBuilder?.build(for: domains.gridDomain?.safeArea),
            sectionBuilder?.build(for: domains.gridDomain?.centringGuides)
        ].unwrapped()
    }

    private func makeCustomSections(for customDomain: DebugMenuCustomDomain) -> [System.TableView.Section] {
        guard let customSectionBuilder = customSectionBuilder else { return [] }

        return customDomain.sections.map(customSectionBuilder.build)
    }

    // MARK: - DebugMenuInteractor

    func start() {
        syncState()
    }

    func close() {
        delegate?.debugMenuDidRequestClosing()
    }

    func selectDomain(at index: Int) {
        selectedDomainIndex = index
    }

    func showLogs() {
        router?.routeToLogs()
    }

    func exportLogs() {
        guard
            let logsData = try? logsExtractor.extract(),
            let logsString = String(data: logsData, encoding: .utf8)
        else {
            return
        }

        router?.routeToActivity(with: logsString)
    }

    func showDocuments() {
        router?.routeToDirectoryViewer(at: FileManager.default.documents)
    }
}
