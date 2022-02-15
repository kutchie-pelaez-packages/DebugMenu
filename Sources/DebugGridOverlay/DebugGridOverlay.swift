import CoreUI
import Tweak

public protocol DebugGridOverlay: WindowOverlay, TweakReceiver {
    var isGridVisible: Bool { get }
    var isSafeAreaVisible: Bool { get }
    var isCentringGuidesVisible: Bool { get }
    var gridHorizontalSpacing: Double { get }
    var gridVerticalSpacing: Double { get }
}
