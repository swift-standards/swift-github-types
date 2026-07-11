//
//  GitHub.Collaborators.API.swift
//  swift-github-types
//
//  Created by Coen ten Thije Boonkkamp on 14/09/2025.
//

import GitHub_Types_Shared

extension GitHub.Collaborators {
    @Cases
    public enum API: Equatable, Sendable {
        // https://docs.github.com/en/rest/collaborators/collaborators#list-repository-collaborators
        case list(owner: String, repo: String, request: GitHub.Collaborators.List.Request? = nil)

        // https://docs.github.com/en/rest/collaborators/collaborators#check-if-a-user-is-a-repository-collaborator
        case check(owner: String, repo: String, username: String)

        // https://docs.github.com/en/rest/collaborators/collaborators#add-a-repository-collaborator
        case add(
            owner: String,
            repo: String,
            username: String,
            request: GitHub.Collaborators.Add.Request? = nil
        )

        // https://docs.github.com/en/rest/collaborators/collaborators#remove-a-repository-collaborator
        case remove(owner: String, repo: String, username: String)

        // https://docs.github.com/en/rest/collaborators/collaborators#get-repository-permissions-for-a-user
        case getPermission(owner: String, repo: String, username: String)

        // https://docs.github.com/en/rest/collaborators/invitations#list-repository-invitations
        case listInvitations(
            owner: String,
            repo: String,
            request: GitHub.Collaborators.Invitations.List.Request? = nil
        )

        // https://docs.github.com/en/rest/collaborators/invitations#update-a-repository-invitation
        case updateInvitation(
            owner: String,
            repo: String,
            invitationId: Int,
            request: GitHub.Collaborators.Invitations.Update.Request
        )

        // https://docs.github.com/en/rest/collaborators/invitations#delete-a-repository-invitation
        case deleteInvitation(owner: String, repo: String, invitationId: Int)
    }
}

extension GitHub.Collaborators.API {
    public struct Router: ParserPrinter, Sendable {
        public init() {}

        public var body: some URLRouting.Router<GitHub.Collaborators.API> {
            OneOf {
                // https://docs.github.com/en/rest/collaborators/collaborators#list-repository-collaborators
                URLRouting.Route(
                    .convert(
                        apply: { (owner: $0.0.0, repo: $0.0.1, request: $0.1) },
                        unapply: { (($0.owner, $0.repo), $0.request) }
                    )
                    .map(.case(GitHub.Collaborators.API.cases.list))
                ) {
                    Method.get
                    Path { "repos" }
                    Path { Parse(.string) }  // owner
                    Path { Parse(.string) }  // repo
                    Path { "collaborators" }
                    Optionally {
                        Parse(
                            .convert(
                                apply: { ($0.0.0.0, $0.0.0.1, $0.0.1, $0.1) },
                                unapply: { ((($0.0, $0.1), $0.2), $0.3) }
                            )
                            .map(
                                .memberwise(
                                    GitHub.Collaborators.List.Request.init,
                                    { ($0.affiliation, $0.permission, $0.perPage, $0.page) }
                                )
                            )
                        ) {
                            URLRouting.Query {
                                Optionally {
                                    Field("affiliation") {
                                        Parse(
                                            .string.representing(
                                                GitHub.Collaborators.List.Request.Affiliation.self
                                            )
                                        )
                                    }
                                }
                                Optionally {
                                    Field("permission") {
                                        Parse(
                                            .string.representing(
                                                GitHub.Collaborators.Permission.self
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
                            }
                        }
                    }
                }

                // https://docs.github.com/en/rest/collaborators/collaborators#check-if-a-user-is-a-repository-collaborator
                URLRouting.Route(
                    .convert(
                        apply: { (owner: $0.0.0, repo: $0.0.1, username: $0.1) },
                        unapply: { (($0.owner, $0.repo), $0.username) }
                    )
                    .map(.case(GitHub.Collaborators.API.cases.check))
                ) {
                    Method.get
                    Path { "repos" }
                    Path { Parse(.string) }  // owner
                    Path { Parse(.string) }  // repo
                    Path { "collaborators" }
                    Path { Parse(.string) }  // username
                }

                // https://docs.github.com/en/rest/collaborators/collaborators#add-a-repository-collaborator
                URLRouting.Route(
                    .convert(
                        apply: { (owner: $0.0.0.0, repo: $0.0.0.1, username: $0.0.1, request: $0.1) },
                        unapply: { ((($0.owner, $0.repo), $0.username), $0.request) }
                    )
                    .map(.case(GitHub.Collaborators.API.cases.add))
                ) {
                    Method.put
                    Path { "repos" }
                    Path { Parse(.string) }  // owner
                    Path { Parse(.string) }  // repo
                    Path { "collaborators" }
                    Path { Parse(.string) }  // username
                    Optionally {
                        URLRouting.Body(.json(GitHub.Collaborators.Add.Request.self))
                    }
                }

                // https://docs.github.com/en/rest/collaborators/collaborators#remove-a-repository-collaborator
                URLRouting.Route(
                    .convert(
                        apply: { (owner: $0.0.0, repo: $0.0.1, username: $0.1) },
                        unapply: { (($0.owner, $0.repo), $0.username) }
                    )
                    .map(.case(GitHub.Collaborators.API.cases.remove))
                ) {
                    Method.delete
                    Path { "repos" }
                    Path { Parse(.string) }  // owner
                    Path { Parse(.string) }  // repo
                    Path { "collaborators" }
                    Path { Parse(.string) }  // username
                }

                // https://docs.github.com/en/rest/collaborators/collaborators#get-repository-permissions-for-a-user
                URLRouting.Route(
                    .convert(
                        apply: { (owner: $0.0.0, repo: $0.0.1, username: $0.1) },
                        unapply: { (($0.owner, $0.repo), $0.username) }
                    )
                    .map(.case(GitHub.Collaborators.API.cases.getPermission))
                ) {
                    Method.get
                    Path { "repos" }
                    Path { Parse(.string) }  // owner
                    Path { Parse(.string) }  // repo
                    Path { "collaborators" }
                    Path { Parse(.string) }  // username
                    Path { "permission" }
                }

                // https://docs.github.com/en/rest/collaborators/invitations#list-repository-invitations
                URLRouting.Route(
                    .convert(
                        apply: { (owner: $0.0.0, repo: $0.0.1, request: $0.1) },
                        unapply: { (($0.owner, $0.repo), $0.request) }
                    )
                    .map(.case(GitHub.Collaborators.API.cases.listInvitations))
                ) {
                    Method.get
                    Path { "repos" }
                    Path { Parse(.string) }  // owner
                    Path { Parse(.string) }  // repo
                    Path { "invitations" }
                    Optionally {
                        Parse(
                            .memberwise(
                                GitHub.Collaborators.Invitations.List.Request.init,
                                { ($0.perPage, $0.page) }
                            )
                        ) {
                            URLRouting.Query {
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

                // https://docs.github.com/en/rest/collaborators/invitations#update-a-repository-invitation
                URLRouting.Route(
                    .convert(
                        apply: { (owner: $0.0.0.0, repo: $0.0.0.1, invitationId: $0.0.1, request: $0.1) },
                        unapply: { ((($0.owner, $0.repo), $0.invitationId), $0.request) }
                    )
                    .map(.case(GitHub.Collaborators.API.cases.updateInvitation))
                ) {
                    Method.patch
                    Path { "repos" }
                    Path { Parse(.string) }  // owner
                    Path { Parse(.string) }  // repo
                    Path { "invitations" }
                    Path { Int.parser() }  // invitationId
                    URLRouting.Body(.json(GitHub.Collaborators.Invitations.Update.Request.self))
                }

                // https://docs.github.com/en/rest/collaborators/invitations#delete-a-repository-invitation
                URLRouting.Route(
                    .convert(
                        apply: { (owner: $0.0.0, repo: $0.0.1, invitationId: $0.1) },
                        unapply: { (($0.owner, $0.repo), $0.invitationId) }
                    )
                    .map(.case(GitHub.Collaborators.API.cases.deleteInvitation))
                ) {
                    Method.delete
                    Path { "repos" }
                    Path { Parse(.string) }  // owner
                    Path { Parse(.string) }  // repo
                    Path { "invitations" }
                    Path { Int.parser() }  // invitationId
                }
            }
        }
    }
}
