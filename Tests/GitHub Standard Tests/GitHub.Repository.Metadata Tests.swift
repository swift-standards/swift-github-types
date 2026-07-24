import RFC_3339
import RFC_3986
import Testing

@testable import GitHub_Standard

extension GitHub.Repository.Metadata {
    @Suite("GitHub.Repository.Metadata.Unit")
    struct Unit {
        @Test("Metadata retains provider vocabulary without Foundation conversion")
        func values() throws(RFC_3986.Error) {
            let owner = GitHub.Owner.Summary(
                id: .init(1),
                login: .init("swiftlang"),
                nodeID: "MDEyOk9yZ2FuaXphdGlvbjE=",
                avatarURL: try RFC_3986.URI("https://avatars.githubusercontent.com/u/1"),
                gravatarID: "",
                url: try RFC_3986.URI("https://api.github.com/users/swiftlang"),
                htmlURL: try RFC_3986.URI("https://github.com/swiftlang"),
                type: "Organization",
                siteAdmin: false
            )
            let createdAt: RFC_3339.DateTime
            do throws(RFC_3339.DateTime.Error) {
                createdAt = try RFC_3339.DateTime("2026-07-22T10:00:00Z")
            } catch {
                Issue.record("invalid RFC 3339 fixture: \(error)")
                return
            }
            let metadata = GitHub.Repository.Metadata(
                id: .init(2),
                nodeID: "R_kgDO",
                name: .init("swift"),
                fullName: "swiftlang/swift",
                owner: owner,
                htmlURL: try RFC_3986.URI("https://github.com/swiftlang/swift"),
                url: try RFC_3986.URI("https://api.github.com/repos/swiftlang/swift"),
                homepage: nil,
                description: "The Swift Programming Language",
                isPrivate: false,
                isFork: false,
                isArchived: false,
                isDisabled: false,
                isTemplate: false,
                hasIssues: true,
                hasProjects: true,
                hasDownloads: true,
                hasWiki: true,
                hasPages: false,
                allowForking: true,
                language: "C++",
                visibility: .public,
                defaultBranch: "main",
                topics: ["swift"],
                license: nil,
                stargazersCount: 1,
                forksCount: 2,
                openIssuesCount: 3,
                watchersCount: 4,
                size: 5,
                createdAt: createdAt,
                updatedAt: createdAt,
                pushedAt: nil
            )

            #expect(metadata.owner.login == .init("swiftlang"))
            #expect(metadata.createdAt == createdAt)
            #expect(metadata.size == UInt64(5))
            #expect(metadata.visibility == .public)
        }
    }
}
