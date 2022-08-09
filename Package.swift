// swift-tools-version: 5.5

import PackageDescription

let package = Package(
    name: "PianoRoll",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [.library(name: "PianoRoll", targets: ["PianoRoll"])],
    targets: [.target(name: "PianoRoll", dependencies: [])]
)

#if swift(>=5.6)
// Add the documentation compiler plugin if possible
package.dependencies.append(
    .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
)
#endif
