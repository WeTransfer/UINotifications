// swift-tools-version:5.5
// We're hiding dev, test, and danger dependencies with // dev to make sure they're not fetched by users of this package.
import PackageDescription

let package = Package(
    name: "UINotifications",
    platforms: [
        .iOS(.v13),
        // dev .macOS(.v10_15)
    ],
    products: [
        .library(name: "UINotifications", targets: ["UINotifications"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-concurrency-extras.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "UINotifications", path: "Sources"),
        .testTarget(
            name: "UINotificationsTests",
            dependencies: [
                "UINotifications",
                .product(name: "ConcurrencyExtras", package: "swift-concurrency-extras")
            ],
            path: "Tests",
            resources: [.copy("Resources/iconToastChevron.png")]
        )
    ]
)
