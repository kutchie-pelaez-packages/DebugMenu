import DebugMenuDomains

struct DebugMenuGridDomainFactory {
    let parent: DebugMenuComp

    func produce() -> DebugMenuGridDomain? {
        guard let debugMenuGridOverlay = parent.debugMenuGridOverlay else { return nil }

        return DebugMenuGridDomain(
            grid: DebugMenuGridDomain.Grid(
                isVisibleResolver: { debugMenuGridOverlay.isGridVisible },
                horizontalSpacingResolver: { debugMenuGridOverlay.gridHorizontalSpacing },
                verticalSpacingResolver: { debugMenuGridOverlay.gridVerticalSpacing }
            ),
            safeArea: DebugMenuGridDomain.SafeArea(
                isVisibleResolver: { debugMenuGridOverlay.isSafeAreaVisible }
            ),
            centringGuides: DebugMenuGridDomain.CentringGuides(
                isVisibleResolver: { debugMenuGridOverlay.isCentringGuidesVisible }
            )
        )
    }
}
