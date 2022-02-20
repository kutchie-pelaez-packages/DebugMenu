import Core
import Tweak

public struct DebugMenuCustomDomain {
    public init(
        title: String,
        sections: [Section]
    ) {
        self.title = title
        self.sections = sections
    }

    public let title: String
    public let sections: [Section]

    public struct Section {
        public init(
            title: String?,
            items: [Item]
        ) {
            self.title = title
            self.items = items
        }

        public let title: String?
        public let items: [Item]
    }

    public enum Item {
        public typealias TweakResolver<Args> = (Args) -> Tweak

        case button(text: StringResolver, tweak: TweakResolver<Void>)
        case selectingButton(text: StringResolver, isSelected: BoolResolver, tweak: TweakResolver<Void>)
        case `switch`(text: StringResolver, enabled: BoolResolver, tweak: TweakResolver<Bool>)
        case stepper(text: StringResolver, value: DoubleResolver, tweak: TweakResolver<Double>)
        case segments(text: StringResolver, items: Resolver<[Any]>, selectedIndex: IntResolver, tweak: TweakResolver<Int>)
    }
}
