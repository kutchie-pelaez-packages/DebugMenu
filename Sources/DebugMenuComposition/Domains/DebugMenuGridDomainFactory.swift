import DebugMenuDomains

struct DebugMenuGridDomainFactory {
    let parent: DebugMenuComp

    func produce() -> DebugMenuGridDomain? {
        guard let debugGridOverlay = parent.debugGridOverlay else { return nil }

        return DebugMenuGridDomain(
            grid: DebugMenuGridDomain.Grid(
                isVisibleResolver: { debugGridOverlay.isGridVisible },
                horizontalSpacingResolver: { debugGridOverlay.gridHorizontalSpacing },
                verticalSpacingResolver: { debugGridOverlay.gridVerticalSpacing }
            ),
            safeArea: DebugMenuGridDomain.SafeArea(
                isVisibleResolver: { debugGridOverlay.isSafeAreaVisible }
            ),
            centringGuides: DebugMenuGridDomain.CentringGuides(
                isVisibleResolver: { debugGridOverlay.isCentringGuidesVisible }
            )
        )
    }
}
