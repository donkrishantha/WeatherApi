// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Network",
    defaultLocalization: "en",
    platforms: [
        /// Add support for all platforms starting from a specific version.
        .iOS(.v15),
        .macOS(.v10_15)
    ],
    products: [
        /// Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Network",
            targets: ["Network"]),
    ],
    targets: [
        /// Targets are the basic building blocks of a package, defining a module or a test suite.
        /// Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Network"),
        .testTarget(
            name: "NetworkTests",
            dependencies: ["Network"]
        ),
    ]
)

//dependencies: [
//    // Dependencies declare other packages that this package depends on.
//    //.product(name: "Combine", package: "Combine.swift")
//    //.package(name: "SwiftPM", url: "https://github.com/SDGGiesbrecht/swift-package-manager.git", .exact("0.50302.0")),
//    //.package(url: "https://github.com/OpenCombine/Combine.git", from: "0.14.0"),
//    //.package(name: "Combine", path: ),
//    //.package(name: "Combine", path: "./Combine"),
//    //.product(name: "Combine", package: "Combine.swift")
//    //.package(name: "Combine", path: "../Combine")
//    //.package(path: "../Combine")
//],
