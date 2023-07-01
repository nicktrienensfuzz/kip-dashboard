// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "kip-dashboard",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
          .package(url: "https://github.com/skelpo/JSON",from: "1.1.4"),
          .package(url: "https://github.com/hummingbird-project/hummingbird",from: "1.5.1"),
          .package(url: "https://github.com/hummingbird-project/hummingbird-core",from: "1.3.1"),
          .package(url: "https://github.com/pointfreeco/swift-tagged",from: "0.10.0"),
          .package(url: "https://github.com/apple/swift-log",from: "1.5.2"),
          .package(url: "https://github.com/kylef/PathKit",from: "1.0.1"),
          .package(url: "https://github.com/apple/swift-atomics",from: "1.1.0"),
          .package(url: "https://github.com/pointfreeco/swift-dependencies",from: "0.5.1"),
          .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.4.0"),
          .package(url: "https://github.com/swift-sprinter/Breeze.git", from: "0.2.0"),
        //    .package(url: "https://github.com/hummingbird-project/hummingbird-lambda.git", exact: "1.0.0-rc.3"),
          .package(url: "https://github.com/nicktrienensfuzz/hummingbird-lambda.git", branch: "main")

    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "kip-dashboard",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "JSON",package: "JSON"),
                .product(name: "Hummingbird",package: "hummingbird"),
                .product(name: "HummingbirdFoundation", package: "hummingbird"),
                .product(name: "HummingbirdTLS", package: "hummingbird-core"),
                .product(name: "Tagged",package: "swift-tagged"),
                .product(name: "Logging",package: "swift-log"),
                .product(name: "PathKit",package: "PathKit"),
                .product(name: "Atomics",package: "swift-atomics"),
                .product(name: "Dependencies",package: "swift-dependencies"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "HummingbirdLambda",package: "hummingbird-lambda"),


            ],
            path: "Sources"),
    ]
)
