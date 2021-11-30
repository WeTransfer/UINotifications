// swift-tools-version:5.5
// We're hiding dev, test, and danger dependencies with // dev to make sure they're not fetched by users of this package.
import PackageDescription

let package = Package(
    name: "UINotifications",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // dev .library(name: "DangerDeps", type: .dynamic, targets: ["DangerDependencies"]), // dev
        .library(name: "UINotifications", type: .static, targets: ["UINotifications"])
    ],
    dependencies: [
        // dev .package(name: "danger-swift", url: "https://github.com/danger/swift", from: "3.12.3"),
        // dev .package(name: "WeTransferPRLinter", path: "Submodules/WeTransfer-iOS-CI/WeTransferPRLinter")
    ],
    targets: [
        // dev .target(name: "DangerDependencies", dependencies: [
        // dev     .product(name: "Danger", package: "danger-swift"),
        // dev     .product(name: "WeTransferPRLinter", package: "WeTransferPRLinter")
        // dev ], path: "Submodules/WeTransfer-iOS-CI/DangerFakeSources", sources: ["DangerFakeSource.swift"]),
        .target(name: "UINotifications", path: "Sources")
    ]
)
