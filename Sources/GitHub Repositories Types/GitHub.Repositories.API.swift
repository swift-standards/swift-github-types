//
//  GitHub.Repositories.API.swift
//  swift-github-types
//
//  Created by Coen ten Thije Boonkkamp on 22/08/2025.
//

import GitHub_Types_Shared

extension GitHub.Repositories {
    @Cases
    public enum API: Equatable, Sendable {
        // https://docs.github.com/en/rest/repos/repos#list-repositories-for-the-authenticated-user
        case list(request: GitHub.Repositories.List.Request? = nil)

        // https://docs.github.com/en/rest/repos/repos#get-a-repository
        case get(owner: String, repo: String)

        // https://docs.github.com/en/rest/repos/repos#create-a-repository-for-the-authenticated-user
        case create(request: Create.Request)

        // https://docs.github.com/en/rest/repos/repos#update-a-repository
        case update(owner: String, repo: String, request: Update.Request)

        // https://docs.github.com/en/rest/repos/repos#delete-a-repository
        case delete(owner: String, repo: String)
    }
}

extension GitHub.Repositories.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<GitHub.Repositories.API> {
            OneOf {
                // https://docs.github.com/en/rest/repos/repos#list-repositories-for-the-authenticated-user
                URLRouting.Route(.case(GitHub.Repositories.API.cases.list)) {
                    Method.get
                    Path { "user" }
                    Path { "repos" }
                    Optionally {
                        Parse(
                            .convert(
                                apply: {
                                    (
                                        $0.0.0.0.0.0.0.0.0,  // visibility
                                        $0.0.0.0.0.0.0.0.1,  // affiliation
                                        $0.0.0.0.0.0.0.1,  // type
                                        $0.0.0.0.0.0.1,  // sort
                                        $0.0.0.0.0.1,  // direction
                                        $0.0.0.0.1,  // perPage
                                        $0.0.0.1,  // page
                                        $0.0.1,  // since
                                        $0.1  // before
                                    )
                                },
                                unapply: {
                                    (((((((($0.0, $0.1), $0.2), $0.3), $0.4), $0.5), $0.6), $0.7), $0.8)
                                }
                            )
                            .map(
                                .memberwise(
                                    GitHub.Repositories.List.Request.init,
                                    {
                                        (
                                            $0.visibility, $0.affiliation, $0.type, $0.sort,
                                            $0.direction, $0.perPage, $0.page, $0.since, $0.before
                                        )
                                    }
                                )
                            )
                        ) {
                            URLRouting.Query {
                                Optionally {
                                    Field("visibility") {
                                        Parse(
                                            .string.representing(
                                                GitHub.Repositories.List.Request.Visibility.self
                                            )
                                        )
                                    }
                                }
                                Optionally {
                                    Field("affiliation") { Parse(.string) }
                                }
                                Optionally {
                                    Field("type") {
                                        Parse(
                                            .string.representing(
                                                GitHub.Repositories.List.Request.RepoType.self
                                            )
                                        )
                                    }
                                }
                                Optionally {
                                    Field("sort") {
                                        Parse(
                                            .string.representing(
                                                GitHub.Repositories.List.Request.Sort.self
                                            )
                                        )
                                    }
                                }
                                Optionally {
                                    Field("direction") {
                                        Parse(
                                            .string.representing(
                                                GitHub.Repositories.List.Request.Direction.self
                                            )
                                        )
                                    }
                                }
                                Optionally {
                                    Field("per_page") { Int.parser() }
                                }
                                Optionally {
                                    Field("page") { Int.parser() }
                                }
                                Optionally {
                                    Field("since") {
                                        Parse(
                                            .string.map(
                                                Parser.Conversion.Witness<String, Date, Parser.Conversion.Error>(
                                                    apply: { (string: String) throws(Parser.Conversion.Error) -> Date in
                                                        guard let date = ISO8601DateFormatter().date(from: string) else {
                                                            throw Parser.Conversion.Error.unrepresentable
                                                        }
                                                        return date
                                                    },
                                                    unapply: {
                                                        ISO8601DateFormatter().string(from: $0)
                                                    }
                                                )
                                            )
                                        )
                                    }
                                }
                                Optionally {
                                    Field("before") {
                                        Parse(
                                            .string.map(
                                                Parser.Conversion.Witness<String, Date, Parser.Conversion.Error>(
                                                    apply: { (string: String) throws(Parser.Conversion.Error) -> Date in
                                                        guard let date = ISO8601DateFormatter().date(from: string) else {
                                                            throw Parser.Conversion.Error.unrepresentable
                                                        }
                                                        return date
                                                    },
                                                    unapply: {
                                                        ISO8601DateFormatter().string(from: $0)
                                                    }
                                                )
                                            )
                                        )
                                    }
                                }
                            }
                        }
                    }
                }

                // https://docs.github.com/en/rest/repos/repos#get-a-repository
                URLRouting.Route(
                    .convert(
                        apply: { (owner: $0.0, repo: $0.1) },
                        unapply: { ($0.owner, $0.repo) }
                    )
                    .map(.case(GitHub.Repositories.API.cases.get))
                ) {
                    Method.get
                    Path { "repos" }
                    Path { Parse(.string) }  // owner
                    Path { Parse(.string) }  // repo
                }

                // https://docs.github.com/en/rest/repos/repos#create-a-repository-for-the-authenticated-user
                URLRouting.Route(.case(GitHub.Repositories.API.cases.create)) {
                    Method.post
                    Path { "user" }
                    Path { "repos" }
                    URLRouting.Body(.json(GitHub.Repositories.Create.Request.self))
                }

                // https://docs.github.com/en/rest/repos/repos#update-a-repository
                URLRouting.Route(
                    .convert(
                        apply: { (owner: $0.0.0, repo: $0.0.1, request: $0.1) },
                        unapply: { (($0.owner, $0.repo), $0.request) }
                    )
                    .map(.case(GitHub.Repositories.API.cases.update))
                ) {
                    Method.patch
                    Path { "repos" }
                    Path { Parse(.string) }  // owner
                    Path { Parse(.string) }  // repo
                    URLRouting.Body(.json(GitHub.Repositories.Update.Request.self))
                }

                // https://docs.github.com/en/rest/repos/repos#delete-a-repository
                URLRouting.Route(
                    .convert(
                        apply: { (owner: $0.0, repo: $0.1) },
                        unapply: { ($0.owner, $0.repo) }
                    )
                    .map(.case(GitHub.Repositories.API.cases.delete))
                ) {
                    Method.delete
                    Path { "repos" }
                    Path { Parse(.string) }  // owner
                    Path { Parse(.string) }  // repo
                }
            }
        }
    }
}
