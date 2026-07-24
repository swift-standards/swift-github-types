import Tagged_Primitives

extension GitHub.Organization {
    /// A GitHub organization's name.
    ///
    /// Modelled as `Tagged` rather than a bespoke `rawValue` struct so the
    /// ecosystem's Tagged conventions apply and the conditional conformances
    /// (`Codable`, `Equatable`, `Hashable`, `Sendable`) come from `Underlying`
    /// instead of being hand-maintained here. Access the value via
    /// `.underlying`; construct with `Name(_:)`.
    public typealias Name = Tagged<GitHub.Organization, String>
}
