import Tagged_Primitives

extension GitHub.Repository {
    /// A GitHub repository's name (the path segment, not the owner/name pair).
    ///
    /// Modelled as `Tagged` rather than a bespoke `rawValue` struct so the
    /// ecosystem's Tagged conventions apply and the conditional conformances
    /// (`Codable`, `Equatable`, `Hashable`, `Sendable`) come from `Underlying`
    /// instead of being hand-maintained here. Access the value via
    /// `.underlying`; construct with `Name(_:)`.
    public typealias Name = Tagged<GitHub.Repository, String>
}
