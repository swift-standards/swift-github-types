import Testing

@testable import GitHub_Standard

extension GitHub.Repository.Content {
    @Suite("GitHub.Repository.Content.Unit")
    struct Unit {
        @Test("The operation retains the provider content request")
        func operation() throws {
            let path = try #require(Path(segments: ["Sources", "Package.swift"]))
            let request = Request(
                organization: .init("swift-institute"),
                repository: .init("Workspace"),
                path: path
            )

            #expect(Operation(request: request).request == request)
            #expect(request.path.segments == ["Sources", "Package.swift"])
        }

        @Test("Content paths are nonempty relative segment sequences")
        func path() {
            #expect(Path(segments: []) == nil)
            #expect(Path(segments: [""]) == nil)
            #expect(Path(segments: [".."]) == nil)
            #expect(Path(segments: ["Package.swift"])?.segments == ["Package.swift"])
        }

        @Test("Provider content kinds retain their wire spellings")
        func kind() {
            #expect(Kind(rawValue: "dir") == .directory)
            #expect(Kind(rawValue: "file") == .file)
            #expect(Kind(rawValue: "symlink") == .symbolicLink)
            #expect(Kind(rawValue: "submodule") == .submodule)
        }
    }
}
