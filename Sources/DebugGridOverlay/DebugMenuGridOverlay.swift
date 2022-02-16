import CoreUI
import Tweak

public protocol DebugMenuGridOverlay: WindowOverlay, TweakReceiver {
    var isGridVisible: Bool { get }
    var isSafeAreaVisible: Bool { get }
    var isCentringGuidesVisible: Bool { get }
    var gridHorizontalSpacing: Double { get }
    var gridVerticalSpacing: Double { get }
}
