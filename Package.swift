// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SavingsTracker",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "SavingsTracker", targets: ["SavingsTracker"])
    ],
    targets: [
        .executableTarget(
            name: "SavingsTracker",
            path: "SavingsTracker"),
        .testTarget(
            name: "SavingsTrackerTests",
            dependencies: ["SavingsTracker"],
            path: "SavingsTrackerTests")
    ]
)
