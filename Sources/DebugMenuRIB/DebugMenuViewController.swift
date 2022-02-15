import Core
import CoreUI
import CoreRIB
import UIKit

protocol DebugMenuViewController: ViewController {
    var state: System.TableView.State { get set }
    func setDomains(_ domains: [String])
}

final class DebugMenuViewControllerImpl: ViewController, DebugMenuViewController {
    init(interactor: DebugMenuInteractor) {
        self.interactor = interactor
        super.init()
    }

    private let interactor: DebugMenuInteractor

    @objc private func handleCloseButton() {
        interactor.close()
    }

    // MARK: - UI

    private var tableView: System.TableView!
    private var segmentedControl: UISegmentedControl?

    override func configureViews() {
        tableView = System.TableView()
        view.addSubview(tableView)
    }

    override func configureNavigationBar() {
        navigationItem.title =  "Debug Menu"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(handleCloseButton)
        )
    }

    override func constraintViews() {
        tableView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }

    override func snapUpdate() {
        tableView.tableHeaderView?.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerX.equalToSuperview()
        }
    }

    // MARK: - DebugMenuView

    var state: System.TableView.State {
        get {
            tableView.state
        } set {
            tableView.state = newValue
        }
    }

    func setDomains(_ domains: [String]) {
        if
            segmentedControl.isNil &&
            domains.count > 1
        {
            segmentedControl = UISegmentedControl(items: domains)
            tableView.tableHeaderView = segmentedControl
            segmentedControl?.selectedSegmentIndex = 0
            segmentedControl?.addAction { [weak self] in
                guard let selectedSegmentIndex = self?.segmentedControl?.selectedSegmentIndex else { return }

                self?.interactor.selectDomain(at: selectedSegmentIndex)
            }
        } else if
            segmentedControl.isNotNil &&
            domains.count <= 1
        {
            tableView.tableHeaderView = nil
            segmentedControl = nil
        }
    }
}
