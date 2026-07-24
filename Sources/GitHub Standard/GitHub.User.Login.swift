import Tagged_Primitives

extension GitHub.User {
    /// A GitHub user's login handle.
    ///
    /// Modelled as `Tagged` rather than a bespoke `rawValue` struct so the
    /// ecosystem's Tagged conventions apply and the conditional conformances
    /// (`Codable`, `Equatable`, `Hashable`, `Sendable`) come from `Underlying`
    /// instead of being hand-maintained here. Access the value via
    /// `.underlying`; construct with `Login(_:)`.
    public typealias Login = Tagged<GitHub.User, String>
}
