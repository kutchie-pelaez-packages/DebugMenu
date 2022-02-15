import Core
import CoreUI
import UIKit

final class DebugMenuOverlayImpl: PassthroughView, WindowOverlay {
    init?(
        environment: Environment,
        delegate: DebugMenuOverlayDelegate
    ) {
        guard environment.isDev else { return nil }

        self.delegate = delegate
        super.init()
    }

    private weak var delegate: DebugMenuOverlayDelegate?
    private var fadingWorkItem: IdentifiableDispatchWorkItem?

    private lazy var initialFABPosition: CGPoint = CGPoint(
        x: maximumHorizontalTranslation - 16,
        y: maximumBottomTranslation - 100
    )
    private var maximumHorizontalTranslation: Double {
        frame.width / 2 - fab.frame.width / 2
    }
    private var maximumTopTranslation: Double {
        frame.height / 2 - fab.frame.height / 2 - safeAreaInsets.top
    }
    private var maximumBottomTranslation: Double {
        frame.height / 2 - fab.frame.height / 2
    }

    // MARK: - UI

    private var fab: DebugMenuButton!

    override func configureViews() {
        fab = DebugMenuButton()
        fab.addAction { [weak self] in
            Impact.generate(.soft)
            self?.delegate?.debugMenuOverlayDidRequestAction()
        }
        fab.addAction(for: [.touchDown]) { [weak self] in
            self?.fadeFABIn()
            self?.scaleFAB(with: 0.9)
        }
        fab.addAction(for: [.touchUpInside, .touchUpOutside]) { [weak self] in
            self?.fadeFABOut()
            self?.scaleFAB(with: 1)
        }
        addSubview(fab)
    }

    override func constraintViews() {
        fab.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    override func postSetup() {
        addPanGestureToFAB()
    }

    override func didSized() {
        fab.transform = CGAffineTransform(
            translationX: initialFABPosition.x,
            y: initialFABPosition.y
        )
    }

    // MARK: -

    private func scaleFAB(with scale: Double) {
        animation(duration: 0.1) {
            self.fab.transform = CGAffineTransform(scale: scale).concatenating(
                CGAffineTransform(
                    translationX: self.fab.transform.translation.x,
                    y: self.fab.transform.translation.y
                )
            )
        }
    }

    private func fadeFABIn() {
        fadingWorkItem?.cancel()
        fab.fadeIn()
    }

    private func fadeFABOut() {
        fadingWorkItem = dispatch(after: .second) {
            self.fab.fadeOut(animated: true)
        }
    }

    // MARK: - Gestures

    private func addPanGestureToFAB() {
        let panGesture = UIPanGestureRecognizer { [weak self] pan in
            guard let self = self else { return }

            let location = pan.location(in: self)
            let transform = CGAffineTransform(
                translationX: (location.x - self.frame.width / 2)
                    .clamped(
                        from: -self.maximumHorizontalTranslation,
                        to: self.maximumHorizontalTranslation
                    ),
                y: (location.y - self.frame.height / 2)
                    .clamped(
                        from: -self.maximumTopTranslation,
                        to: self.maximumBottomTranslation
                    )
            )

            animation(duration: 0.05) {
                self.fab.transform = transform
            }

            switch pan.state {
            case .began, .changed:
                self.fadeFABIn()

            default:
                self.fadeFABOut()
            }
        }
        fab.addGestureRecognizer(panGesture)
    }
}
