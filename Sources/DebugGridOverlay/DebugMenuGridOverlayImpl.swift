import Core
import CoreUI
import Tweak
import UIKit

final class DebugMenuGridOverlayImpl: PassthroughView, DebugMenuGridOverlay {
    init?(environment: Environment) {
        guard environment.isDev else { return nil }

        super.init()
    }

    // MARK: - UI

    private var gridView: DebugMenuGridView!

    override func configureViews() {
        gridView = DebugMenuGridView()
        addSubviews(gridView)
    }

    override func constraintViews() {
        gridView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }

    // MARK: - TweakReceiver

    func receive(_ tweak: Tweak) {
        switch tweak.id {
        case .Grid.updateCentringGuidesVisibility:
            guard let newValue = tweak.args[.Common.newValue] as? Bool else { return }

            gridView.isCentringGuidesVisible = newValue

        case .Grid.updateGridHorizontalSpacing:
            guard let newValue = tweak.args[.Common.newValue] as? Double else { return }

            gridView.gridHorizontalSpacing = newValue

        case .Grid.updateGridVerticalSpacing:
            guard let newValue = tweak.args[.Common.newValue] as? Double else { return }

            gridView.gridVerticalSpacing = newValue

        case .Grid.updateGridVisibility:
            guard let newValue = tweak.args[.Common.newValue] as? Bool else { return }

            gridView.isGridVisible = newValue

        case .Grid.updateSafeAreaVisibility:
            guard let newValue = tweak.args[.Common.newValue] as? Bool else { return }

            gridView.isSafeAreaVisible = newValue

        default:
            break
        }
    }

    // MARK: - GridOverlay

    var isGridVisible: Bool { gridView.isGridVisible }

    var isSafeAreaVisible: Bool { gridView.isSafeAreaVisible }

    var isCentringGuidesVisible: Bool { gridView.isCentringGuidesVisible }

    var gridHorizontalSpacing: Double { gridView.gridHorizontalSpacing }

    var gridVerticalSpacing: Double { gridView.gridVerticalSpacing }
}
