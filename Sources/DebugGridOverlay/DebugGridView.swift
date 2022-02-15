import Core
import CoreUI
import UIKit

private let safeAreaColor = System.Colors.Tint.red.withAlphaComponent(0.25)

private let gridLineWidth = 0.5
private let gridLineColor = System.Colors.Tint.red.withAlphaComponent(0.25)

private let crossLineWidth = 1.5
private let crossDimension = 16.0
private let crossColor = System.Colors.Tint.red.withAlphaComponent(0.5)

final class DebugGridView: PassthroughView {
    var isSafeAreaVisible = false {
        didSet {
            setNeedsDisplay()
        }
    }

    var isGridVisible = false {
        didSet {
            setNeedsDisplay()
        }
    }

    var isCentringGuidesVisible = false {
        didSet {
            setNeedsDisplay()
        }
    }

    @Clamped(0.5...)
    var gridHorizontalSpacing: Double = 8 {
        didSet {
            setNeedsDisplay()
        }
    }

    @Clamped(0.5...)
    var gridVerticalSpacing: Double = 8 {
        didSet {
            setNeedsDisplay()
        }
    }

    private var numberOfVerticalLines: Int {
        Int((bounds.width - safeAreaInsets.horizontal) / gridHorizontalSpacing)
    }

    private var numberOfHorizontalLines: Int {
        Int((bounds.height - safeAreaInsets.vertical) / gridVerticalSpacing)
    }

    // MARK: - UI

    private var safeAreaPath = UIBezierPath()
    private let gridPath = UIBezierPath()
    private let centringGuidesPath = UIBezierPath()

    override func configureViews() {
        backgroundColor = .clear
    }

    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        safeAreaPath.removeAllPoints()
        gridPath.removeAllPoints()
        centringGuidesPath.removeAllPoints()

        if isSafeAreaVisible {
            safeAreaPath.move(to: .zero)
            safeAreaPath.addLine(to: CGPoint(x: bounds.width, y: 0))
            safeAreaPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
            safeAreaPath.addLine(to: CGPoint(x: 0, y: bounds.height))
            safeAreaPath.addLine(to: .zero)

            safeAreaPath.move(to: CGPoint(x: safeAreaInsets.left, y: safeAreaInsets.top))
            safeAreaPath.addLine(to: CGPoint(x: bounds.width - safeAreaInsets.right, y: safeAreaInsets.top))
            safeAreaPath.addLine(to: CGPoint(x: bounds.width - safeAreaInsets.right, y: bounds.height - safeAreaInsets.bottom))
            safeAreaPath.addLine(to: CGPoint(x: safeAreaInsets.left, y: bounds.height - safeAreaInsets.bottom))
            safeAreaPath.addLine(to: CGPoint(x: safeAreaInsets.left, y: safeAreaInsets.top))

            safeAreaPath.usesEvenOddFillRule = true
            safeAreaPath.close()
            safeAreaColor.setFill()
            safeAreaPath.fill()
        }

        if isGridVisible {
            for i in 1...numberOfVerticalLines {
                let start = CGPoint(
                    x: Double(i) * gridHorizontalSpacing + safeAreaInsets.left,
                    y: safeAreaInsets.top
                )
                let end = CGPoint(
                    x: Double(i) * gridHorizontalSpacing + safeAreaInsets.left,
                    y: bounds.height - safeAreaInsets.bottom
                )

                gridPath.move(to: start)
                gridPath.addLine(to: end)
            }

            for i in 1...numberOfHorizontalLines {
                let start = CGPoint(
                    x: safeAreaInsets.left,
                    y: Double(i) * gridVerticalSpacing + safeAreaInsets.top
                )
                let end = CGPoint(
                    x: bounds.width - safeAreaInsets.right,
                    y: CGFloat(i) * gridVerticalSpacing + safeAreaInsets.top
                )

                gridPath.move(to: start)
                gridPath.addLine(to: end)
            }

            gridPath.lineWidth = gridLineWidth
            gridPath.close()
            gridLineColor.setStroke()
            gridPath.stroke()
        }

        if isCentringGuidesVisible {
            func addCross(at centerPoint: CGPoint) {
                centringGuidesPath.move(to: CGPoint(x: centerPoint.x - crossDimension / 2, y: centerPoint.y))
                centringGuidesPath.addLine(to: CGPoint(x: centerPoint.x + crossDimension / 2, y: centerPoint.y))
                centringGuidesPath.move(to: CGPoint(x: centerPoint.x, y: centerPoint.y - crossDimension / 2))
                centringGuidesPath.addLine(to: CGPoint(x: centerPoint.x, y: centerPoint.y + crossDimension / 2))
            }

            let frame = safeAreaLayoutGuide.layoutFrame

            addCross(at: CGPoint(x: frame.minX + frame.width / 4, y: frame.minY + frame.height / 4))
            addCross(at: CGPoint(x: frame.midX, y: frame.minY + frame.height / 4))
            addCross(at: CGPoint(x: frame.minX + frame.width / 4 * 3, y: frame.minY + frame.height / 4))

            addCross(at: CGPoint(x: frame.minX + frame.width / 4, y: frame.midY))
            addCross(at: CGPoint(x: frame.midX, y: frame.midY))
            addCross(at: CGPoint(x: frame.minX + frame.width / 4 * 3, y: frame.midY))

            addCross(at: CGPoint(x: frame.minX + frame.width / 4, y: frame.minY + frame.height / 4 * 3))
            addCross(at: CGPoint(x: frame.midX, y: frame.minY + frame.height / 4 * 3))
            addCross(at: CGPoint(x: frame.minX + frame.width / 4 * 3, y: frame.minY + frame.height / 4 * 3))

            centringGuidesPath.close()
            crossColor.setStroke()
            centringGuidesPath.stroke()
        }
    }
}
