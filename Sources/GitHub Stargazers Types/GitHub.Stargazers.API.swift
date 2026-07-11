//
//  GitHub.Stargazers.API.swift
//  swift-github-types
//
//  Created by Coen ten Thije Boonkkamp on 30/08/2025.
//

import Dependencies
import Foundation
import GitHub_Types_Shared
import URLRouting

extension GitHub.Stargazers {
    @Cases
    public enum API: Equatable, Sendable {
        case list(owner: String, repo: String, request: GitHub.Stargazers.List.Request?)
    }
}

extension GitHub.Stargazers.API {
    // NOTE: no @Witness here — Router has no closure properties (`body` is a
    // computed ParserPrinter, `init()` takes no arguments), matching the sibling
    // Router structs in the other GitHub *Types targets which never carried
    // @DependencyClient. The original attribute was a no-op copy-paste holdover.
    public struct Router: ParserPrinter, Sendable {
        public typealias Input = URLRequestData
        public typealias Output = GitHub.Stargazers.API

        public init() {}

        public var body: some URLRouting.Router<GitHub.Stargazers.API> {
            OneOf {
                URLRouting.Route(
                    .convert(
                        apply: { (owner: $0.0.0, repo: $0.0.1, request: $0.1) },
                        unapply: { (($0.owner, $0.repo), $0.request) }
                    )
                    .map(.case(GitHub.Stargazers.API.cases.list))
                ) {
                    Method.get
                    Path { "repos" }
                    Path { Parse(.string) }  // owner
                    Path { Parse(.string) }  // repo
                    Path { "stargazers" }
                    Headers {
                        // Required header for getting starred_at timestamps
                        Field("Accept") { "application/vnd.github.star+json" }
                    }
                    Optionally {
                        Parse(
                            .memberwise(
                                GitHub.Stargazers.List.Request.init,
                                { ($0.perPage, $0.page) }
                            )
                        ) {
                            Query {
                                Optionally {
                                    Field("per_page") { Int.parser() }
                                }
                                Optionally {
                                    Field("page") { Int.parser() }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
