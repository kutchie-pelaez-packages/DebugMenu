import ActivityRIB
import CoreRIB
import DebugMenuDomains
import DebugMenuRIB
import LocalizationManager
import LogsExtractor
import TweakEmitter

struct DebugMenuDependenciesImpl: DebugMenuDependencies {
    let parent: DebugMenuComp

    // MARK: - Args

    let presentationContext: PresentationContext
    let domains: DebugMenuDomains
    let delegate: DebugMenuDelegate

    // MARK: - Scoped

    var tweakEmitter: TweakEmitter { parent.tweakEmitter }

    var localizationManager: LocalizationManager { parent.localizationManager }

    var logsExtractor: LogsExtractor { parent.logsExtractor }

    var activityFactory: ScopedRouterFactory<ActivityArgs> { parent.activityComposition.activityFactory }
}
