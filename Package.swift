// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "PianoRoll",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [.library(name: "PianoRoll", targets: ["PianoRoll"])],
    targets: [
        .target(name: "PianoRoll", dependencies: []),
        .testTarget(name: "PianoRollTests", dependencies: ["PianoRoll"]),
    ]
)
