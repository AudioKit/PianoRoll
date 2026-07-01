// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "PianoRoll",
    platforms: [.macOS(.v13), .iOS(.v16)],
    products: [.library(name: "PianoRoll", targets: ["PianoRoll"])],
    targets: [
        .target(name: "PianoRoll", dependencies: []),
        .testTarget(name: "PianoRollTests", dependencies: ["PianoRoll"]),
    ]
)
