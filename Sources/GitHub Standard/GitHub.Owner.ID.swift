import Tagged_Primitives

extension GitHub.Owner {
    /// GitHub's numeric owner identifier.
    ///
    /// Modelled as `Tagged` rather than a bespoke `rawValue` struct so the
    /// ecosystem's Tagged conventions apply and the conditional conformances
    /// (`Codable`, `Equatable`, `Hashable`, `Sendable`) come from `Underlying`
    /// instead of being hand-maintained here. Access the value via
    /// `.underlying`; construct with `ID(_:)`.
    public typealias ID = Tagged<GitHub.Owner, UInt64>
}
