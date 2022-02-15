import Combine
import Core
import CoreUI
import DebugMenuDomains

protocol DebugMenuInteractor {
    func close()
    func selectDomain(at index: Int)
}

final class DebugMenuInteractorImpl: DebugMenuInteractor {
    init(
        domains: DebugMenuDomains,
        sectionBuilder: DebugMenuSectionBuilder,
        delegate: DebugMenuDelegate
    ) {
        self.domains = domains
        self.sectionBuilder = sectionBuilder
        self.delegate = delegate
        subscribeToEvents()
    }

    private let domains: DebugMenuDomains
    private let sectionBuilder: DebugMenuSectionBuilder
    private weak var delegate: DebugMenuDelegate?

    weak var router: DebugMenuRouter?
    weak var viewController: DebugMenuViewController?

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
            safeCrash()
            sections = []
        }

        viewController?.state = System.TableView.State(sections: sections)
        viewController?.setDomains(
            [
                domains.generalDomain.isNotNil ? "General" : nil,
                domains.gridDomain.isNotNil ? "Grid" : nil,
            ].unwrapped()
        )
    }

    private func makeGeneralSections() -> [System.TableView.Section] {
        [
            sectionBuilder.build(for: domains.generalDomain?.localization),
            sectionBuilder.build(for: domains.generalDomain?.userInterface),
            sectionBuilder.build(for: domains.generalDomain?.session),
            sectionBuilder.build(for: domains.generalDomain?.onboarding)
        ].unwrapped()
    }

    private func makeGridSections() -> [System.TableView.Section] {
        [
            sectionBuilder.build(for: domains.gridDomain?.grid),
            sectionBuilder.build(for: domains.gridDomain?.safeArea),
            sectionBuilder.build(for: domains.gridDomain?.centringGuides),
        ].unwrapped()
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
}
