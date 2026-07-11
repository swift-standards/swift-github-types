// swift-tools-version: 6.3.3

import PackageDescription

extension String {
    static let githubTypes: Self = "GitHub Types"
    static let githubTrafficTypes: Self = "GitHub Traffic Types"
    static let githubRepositoriesTypes: Self = "GitHub Repositories Types"
    static let githubStargazersTypes: Self = "GitHub Stargazers Types"
    static let githubOAuthTypes: Self = "GitHub OAuth Types"
    static let githubCollaboratorsTypes: Self = "GitHub Collaborators Types"
    static let githubIssuesTypes: Self = "GitHub Issues Types"
    static let githubPullRequestsTypes: Self = "GitHub Pull Requests Types"
    static let githubActionsTypes: Self = "GitHub Actions Types"
    static let githubUsersTypes: Self = "GitHub Users Types"
    static let githubOrganizationsTypes: Self = "GitHub Organizations Types"
    static let githubWebhooksTypes: Self = "GitHub Webhooks Types"
    static let githubTypesShared: Self = "GitHub Types Shared"
}

extension Target.Dependency {
    static var githubTypes: Self { .target(name: .githubTypes) }
    static var githubTrafficTypes: Self { .target(name: .githubTrafficTypes) }
    static var githubRepositoriesTypes: Self { .target(name: .githubRepositoriesTypes) }
    static var githubStargazersTypes: Self { .target(name: .githubStargazersTypes) }
    static var githubOAuthTypes: Self { .target(name: .githubOAuthTypes) }
    static var githubCollaboratorsTypes: Self { .target(name: .githubCollaboratorsTypes) }
    static var githubIssuesTypes: Self { .target(name: .githubIssuesTypes) }
    static var githubPullRequestsTypes: Self { .target(name: .githubPullRequestsTypes) }
    static var githubActionsTypes: Self { .target(name: .githubActionsTypes) }
    static var githubUsersTypes: Self { .target(name: .githubUsersTypes) }
    static var githubOrganizationsTypes: Self { .target(name: .githubOrganizationsTypes) }
    static var githubWebhooksTypes: Self { .target(name: .githubWebhooksTypes) }
    static var githubTypesShared: Self { .target(name: .githubTypesShared) }
}

extension Target.Dependency {
    static var dependencies: Self {
        .product(name: "Dependencies", package: "swift-dependencies")
    }
    static var taggedPrimitives: Self {
        .product(name: "Tagged Primitives", package: "swift-tagged-primitives")
    }
    static var dual: Self {
        .product(name: "Dual", package: "swift-dual")
    }
    static var urlRouting: Self {
        .product(name: "URLRouting", package: "swift-url-routing")
    }
    static var emailAddress: Self {
        .product(name: "EmailAddress", package: "swift-emailaddress")
    }
}

let package = Package(
    name: "swift-github-types",
    platforms: [
        .macOS(.v26),
        .iOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26),
    ],
    products: [
        .library(name: .githubTypes, targets: [.githubTypes]),
        .library(name: .githubTrafficTypes, targets: [.githubTrafficTypes]),
        .library(name: .githubRepositoriesTypes, targets: [.githubRepositoriesTypes]),
        .library(name: .githubStargazersTypes, targets: [.githubStargazersTypes]),
        .library(name: .githubOAuthTypes, targets: [.githubOAuthTypes]),
        .library(name: .githubCollaboratorsTypes, targets: [.githubCollaboratorsTypes]),
        .library(name: .githubTypesShared, targets: [.githubTypesShared]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-foundations/swift-dependencies.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-tagged-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-emailaddress.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-dual.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-url-routing.git", branch: "main"),
    ],
    targets: [
        .target(
            name: .githubTypesShared,
            dependencies: [
                .dependencies,
                .taggedPrimitives,
                .dual,
                .urlRouting,
            ]
        ),
        .target(
            name: .githubTypes,
            dependencies: [
                .githubTypesShared,
                .githubTrafficTypes,
                .githubRepositoriesTypes,
                .githubStargazersTypes,
                .githubOAuthTypes,
                .githubCollaboratorsTypes,
                .dependencies,
            ]
        ),
        .target(
            name: .githubTrafficTypes,
            dependencies: [
                .githubTypesShared,
                .dependencies,
                .taggedPrimitives,
                .dual,
                .urlRouting,
            ]
        ),
        .target(
            name: .githubRepositoriesTypes,
            dependencies: [
                .githubTypesShared,
                .dependencies,
                .taggedPrimitives,
                .dual,
                .urlRouting,
            ]
        ),
        .target(
            name: .githubStargazersTypes,
            dependencies: [
                .githubTypesShared,
                .dependencies,
                .taggedPrimitives,
                .dual,
                .urlRouting,
            ]
        ),
        .target(
            name: .githubOAuthTypes,
            dependencies: [
                .githubTypesShared,
                .dependencies,
                .taggedPrimitives,
                .dual,
                .urlRouting,
                .emailAddress,
            ]
        ),
        .target(
            name: .githubCollaboratorsTypes,
            dependencies: [
                .githubTypesShared,
                .dependencies,
                .taggedPrimitives,
                .dual,
                .urlRouting,
            ]
        ),
        .testTarget(
            name: "GitHub Types Tests",
            dependencies: [.githubTypes]
        ),
        .testTarget(
            name: "GitHub Traffic Types Tests",
            dependencies: [.githubTrafficTypes]
        ),
        .testTarget(
            name: "GitHub Repositories Types Tests",
            dependencies: [.githubRepositoriesTypes]
        ),
    ],
    swiftLanguageModes: [.v6]
)
