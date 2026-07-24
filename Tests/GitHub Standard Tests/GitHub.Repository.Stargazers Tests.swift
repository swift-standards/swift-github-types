import RFC_3339
import RFC_3986
import Testing

@testable import GitHub_Standard

extension GitHub.Repository.Stargazers {
    @Suite("GitHub.Repository.Stargazers.Unit")
    struct Unit {
        @Test("Stargazers preserve login and starred-at wire semantics")
        func response() throws(RFC_3986.Error) {
            let user = GitHub.User.Summary(
                id: .init(42),
                login: .init("octocat"),
                nodeID: "MDQ6VXNlcjE=",
                avatarURL: try RFC_3986.URI("https://avatars.githubusercontent.com/u/1"),
                gravatarID: "",
                url: try RFC_3986.URI("https://api.github.com/users/octocat"),
                htmlURL: try RFC_3986.URI("https://github.com/octocat"),
                type: "User",
                siteAdmin: false
            )
            let starredAt: RFC_3339.DateTime
            do throws(RFC_3339.DateTime.Error) {
                starredAt = try RFC_3339.DateTime("2026-07-22T10:00:00Z")
            } catch {
                Issue.record("invalid RFC 3339 fixture: \(error)")
                return
            }
            let stargazer = Stargazer(user: user, starredAt: starredAt)
            let response = Response(stargazers: [stargazer])

            #expect(response.stargazers.first?.user.login == .init("octocat"))
            #expect(response.stargazers.first?.starredAt == starredAt)
        }

        @Test("Pagination uses the shared bounded GitHub page vocabulary")
        func request() {
            let request = Request(
                owner: .init("swiftlang"),
                repository: .init("swift"),
                page: .first,
                size: .maximum
            )

            #expect(Operation(request: request).request == request)
            // swift-linter:disable:next raw value access
            // REASON: the test's purpose is the newtype's raw wire boundary —
            //   `.first` must serialize as page 1 on the GitHub wire.
            #expect(request.page?.rawValue == 1)
            // swift-linter:disable:next raw value access
            // REASON: the test's purpose is the newtype's raw wire boundary —
            //   `.maximum` must serialize as per_page 100 on the GitHub wire.
            #expect(request.size?.rawValue == 100)
        }
    }
}
