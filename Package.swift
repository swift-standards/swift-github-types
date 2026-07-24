// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-github-standard",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(
            name: "GitHub Standard",
            targets: ["GitHub Standard"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-standards/swift-emailaddress-standard.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-ietf/swift-rfc-3339.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-ietf/swift-rfc-3986.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-primitives/swift-tagged-primitives.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "GitHub Standard",
            dependencies: [
                .product(
                    name: "EmailAddress Standard",
                    package: "swift-emailaddress-standard"
                ),
                .product(name: "RFC 3339", package: "swift-rfc-3339"),
                .product(name: "RFC 3986", package: "swift-rfc-3986"),
                // GitHub.Repository.ID / GitHub.Owner.ID are Tagged<_, UInt64>.
                .product(name: "Tagged Primitives", package: "swift-tagged-primitives"),
            ]
        ),
        .testTarget(
            name: "GitHub Standard Tests",
            dependencies: ["GitHub Standard"]
        ),
    ],
    swiftLanguageModes: [.v6]
)
