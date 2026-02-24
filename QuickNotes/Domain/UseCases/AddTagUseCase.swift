import Foundation

// MARK: - Protocol

/// Protocol for creating and persisting a new tag.
protocol AddTagUseCaseProtocol {
    /// Creates a new tag with the given name and color, persists it, and returns it.
    func execute(name: String, colorHex: String) async throws -> Tag
}

// MARK: - Implementation

/// Creates a tag and adds it to the repository.
final class AddTagUseCase: AddTagUseCaseProtocol {

    private let repository: TagRepositoryProtocol

    init(repository: TagRepositoryProtocol) {
        self.repository = repository
    }

    func execute(name: String, colorHex: String) async throws -> Tag {
        let tag = Tag(name: name, colorHex: colorHex)
        try await repository.addTag(tag)
        return tag
    }
}
