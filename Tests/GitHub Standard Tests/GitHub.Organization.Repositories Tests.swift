import Testing

@testable import GitHub_Standard

extension GitHub.Organization.Repositories {
    @Suite("GitHub.Organization.Repositories.Unit")
    struct Unit {
        @Test("The request retains semantic organization and pagination values")
        func request() {
            let request = GitHub.Organization.Repositories.Request(
                organization: .init("swiftlang"),
                type: .public,
                page: .first,
                size: .maximum
            )

            #expect(request.organization.underlying == "swiftlang")
            #expect(request.type == .public)
            #expect(request.page.rawValue == 1)
            #expect(request.size.rawValue == 100)
        }

        @Test("Page values enforce GitHub's published bounds")
        func page() {
            #expect(GitHub.Page.Number(rawValue: 0) == nil)
            #expect(GitHub.Page.Number(rawValue: 1)?.rawValue == 1)
            #expect(GitHub.Page.Size(rawValue: 0) == nil)
            #expect(GitHub.Page.Size(rawValue: 100)?.rawValue == 100)
            #expect(GitHub.Page.Size(rawValue: 101) == nil)
        }

        @Test("The response preserves repository identity and public state")
        func response() {
            let repository = GitHub.Repository.Summary(
                id: .init(42),
                name: .init("swift"),
                archived: false,
                disabled: false,
                fork: false,
                visibility: .public
            )
            let response = GitHub.Organization.Repositories.Response(
                repositories: [repository]
            )

            #expect(response.repositories == [repository])
        }
    }
}
