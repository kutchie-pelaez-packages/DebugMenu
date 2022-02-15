// swift-tools-version:5.3.0

import PackageDescription

let package = Package(
    name: "DebugMenu",
    platforms: [
        .iOS("15")
    ],
    products: [
        .library(
            name: "DebugMenuComposition",
            targets: [
                "DebugMenuComposition"
            ]
        ),
        .library(
            name: "DebugMenuRIB",
            targets: [
                "DebugMenuRIB"
            ]
        ),
        .library(
            name: "DebugMenuDomains",
            targets: [
                "DebugMenuDomains"
            ]
        ),
        .library(
            name: "DebugMenuOverlay",
            targets: [
                "DebugMenuOverlay"
            ]
        ),
        .library(
            name: "DebugGridOverlay",
            targets: [
                "DebugGridOverlay"
            ]
        )
    ],
    dependencies: [
        .package(name: "Appearance", url: "https://github.com/kutchie-pelaez-packages/Appearance.git", .branch("master")),
        .package(name: "Core", url: "https://github.com/kutchie-pelaez-packages/Core.git", .branch("master")),
        .package(name: "CoreRIB", url: "https://github.com/kutchie-pelaez-packages/CoreRIB.git", .branch("master")),
        .package(name: "CoreUI", url: "https://github.com/kutchie-pelaez-packages/CoreUI.git", .branch("master")),
        .package(name: "Localization", url: "https://github.com/kutchie-pelaez-packages/Localization.git", .branch("master")),
        .package(name: "SessionManager", url: "https://github.com/kutchie-pelaez-packages/SessionManager.git", .branch("master")),
        .package(name: "Tweaks", url: "https://github.com/kutchie-pelaez-packages/Tweaks.git", .branch("master")),
        .package(name: "Wording", url: "https://github.com/kutchie-pelaez-packages/Wording.git", .branch("master"))
    ],
    targets: [
        .target(
            name: "DebugMenuComposition",
            dependencies: [
                .product(name: "AppearanceManager", package: "Appearance"),
                .product(name: "Core", package: "Core"),
                .product(name: "CoreRIB", package: "CoreRIB"),
                .product(name: "CoreUI", package: "CoreUI"),
                .product(name: "LocalizationManager", package: "Localization"),
                .product(name: "SessionManager", package: "SessionManager"),
                .product(name: "TweakEmitter", package: "Tweaks"),
                .product(name: "WordingManager", package: "Wording"),
                .target(name: "DebugGridOverlay"),
                .target(name: "DebugMenuDomains"),
                .target(name: "DebugMenuOverlay"),
                .target(name: "DebugMenuRIB")
            ]
        ),
        .target(
            name: "DebugMenuRIB",
            dependencies: [
                .product(name: "AppearanceStyle", package: "Appearance"),
                .product(name: "Core", package: "Core"),
                .product(name: "CoreRIB", package: "CoreRIB"),
                .product(name: "CoreUI", package: "CoreUI"),
                .product(name: "Language", package: "Localization"),
                .product(name: "LocalizationManager", package: "Localization"),
                .product(name: "SessionManager", package: "SessionManager"),
                .product(name: "Tweak", package: "Tweaks"),
                .product(name: "TweakEmitter", package: "Tweaks"),
                .product(name: "Wording", package: "Wording"),
                .target(name: "DebugMenuDomains")
            ]
        ),
        .target(
            name: "DebugMenuDomains",
            dependencies: [
                .product(name: "AppearanceStyle", package: "Appearance"),
                .product(name: "Core", package: "Core"),
                .product(name: "Language", package: "Localization")
            ]
        ),
        .target(
            name: "DebugMenuOverlay",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "CoreUI", package: "CoreUI")
            ]
        ),
        .target(
            name: "DebugGridOverlay",
            dependencies: [
                .product(name: "Core", package: "Core"),
                .product(name: "CoreUI", package: "CoreUI"),
                .product(name: "Tweak", package: "Tweaks")
            ]
        )
    ]
)
