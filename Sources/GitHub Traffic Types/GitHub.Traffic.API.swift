//
//  GitHub.Traffic.API.swift
//  swift-github-types
//
//  Created by Coen ten Thije Boonkkamp on 22/08/2025.
//

import GitHub_Types_Shared

extension GitHub.Traffic {
    @Cases
    public enum API: Equatable, Sendable {
        // https://docs.github.com/en/rest/metrics/traffic#get-repository-views
        case views(owner: String, repo: String, per: Per?)

        // https://docs.github.com/en/rest/metrics/traffic#get-repository-clones
        case clones(owner: String, repo: String, per: Per?)

        // https://docs.github.com/en/rest/metrics/traffic#get-top-referral-paths
        case paths(owner: String, repo: String)

        // https://docs.github.com/en/rest/metrics/traffic#get-top-referral-sources
        case referrers(owner: String, repo: String)
    }
}

extension GitHub.Traffic.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<GitHub.Traffic.API> {
            OneOf {
                // https://docs.github.com/en/rest/metrics/traffic#get-repository-views
                URLRouting.Route(
                    .convert(
                        apply: { (owner: $0.0.0, repo: $0.0.1, per: $0.1) },
                        unapply: { (($0.owner, $0.repo), $0.per) }
                    )
                    .map(.case(GitHub.Traffic.API.cases.views))
                ) {
                    Method.get
                    Path { "repos" }
                    Path { Parse(.string) }  // owner
                    Path { Parse(.string) }  // repo
                    Path { "traffic" }
                    Path { "views" }
                    URLRouting.Query {
                        Optionally {
                            Field("per") { Parse(.string.representing(GitHub.Traffic.Per.self)) }
                        }
                    }
                }

                // https://docs.github.com/en/rest/metrics/traffic#get-repository-clones
                URLRouting.Route(
                    .convert(
                        apply: { (owner: $0.0.0, repo: $0.0.1, per: $0.1) },
                        unapply: { (($0.owner, $0.repo), $0.per) }
                    )
                    .map(.case(GitHub.Traffic.API.cases.clones))
                ) {
                    Method.get
                    Path { "repos" }
                    Path { Parse(.string) }  // owner
                    Path { Parse(.string) }  // repo
                    Path { "traffic" }
                    Path { "clones" }
                    URLRouting.Query {
                        Optionally {
                            Field("per") { Parse(.string.representing(GitHub.Traffic.Per.self)) }
                        }
                    }
                }

                // https://docs.github.com/en/rest/metrics/traffic#get-top-referral-paths
                URLRouting.Route(
                    .convert(
                        apply: { (owner: $0.0, repo: $0.1) },
                        unapply: { ($0.owner, $0.repo) }
                    )
                    .map(.case(GitHub.Traffic.API.cases.paths))
                ) {
                    Method.get
                    Path { "repos" }
                    Path { Parse(.string) }  // owner
                    Path { Parse(.string) }  // repo
                    Path { "traffic" }
                    Path { "popular" }
                    Path { "paths" }
                }

                // https://docs.github.com/en/rest/metrics/traffic#get-top-referral-sources
                URLRouting.Route(
                    .convert(
                        apply: { (owner: $0.0, repo: $0.1) },
                        unapply: { ($0.owner, $0.repo) }
                    )
                    .map(.case(GitHub.Traffic.API.cases.referrers))
                ) {
                    Method.get
                    Path { "repos" }
                    Path { Parse(.string) }  // owner
                    Path { Parse(.string) }  // repo
                    Path { "traffic" }
                    Path { "popular" }
                    Path { "referrers" }
                }
            }
        }
    }
}
