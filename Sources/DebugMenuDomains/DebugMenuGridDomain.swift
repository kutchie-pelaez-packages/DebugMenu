import Core

public struct DebugMenuGridDomain {
    public init(
        grid: Grid?,
        safeArea: SafeArea?,
        centringGuides: CentringGuides?
    ) {
        self.grid = grid
        self.safeArea = safeArea
        self.centringGuides = centringGuides
    }

    public let grid: Grid?
    public let safeArea: SafeArea?
    public let centringGuides: CentringGuides?

    public struct Grid {
        public init(
            isVisibleResolver: @escaping BoolResolver,
            horizontalSpacingResolver: @escaping DoubleResolver,
            verticalSpacingResolver: @escaping DoubleResolver
        ) {
            self.isVisibleResolver = isVisibleResolver
            self.horizontalSpacingResolver = horizontalSpacingResolver
            self.verticalSpacingResolver = verticalSpacingResolver
        }
        public let isVisibleResolver: BoolResolver
        public let horizontalSpacingResolver: DoubleResolver
        public let verticalSpacingResolver: DoubleResolver
    }

    public struct SafeArea {
        public init(isVisibleResolver: @escaping BoolResolver) {
            self.isVisibleResolver = isVisibleResolver
        }
        public let isVisibleResolver: BoolResolver
    }

    public struct CentringGuides {
        public init(isVisibleResolver: @escaping BoolResolver) {
            self.isVisibleResolver = isVisibleResolver
        }
        public let isVisibleResolver: BoolResolver
    }
}
