import Foundation

// MARK: - Protocol

/// Protocol for fetching all tags.
protocol GetTagsUseCaseProtocol {
    /// Fetches all available tags.
    func execute() async throws -> [Tag]
}

// MARK: - Implementation

/// Fetches all tags from the repository.
final class GetTagsUseCase: GetTagsUseCaseProtocol {

    private let repository: TagRepositoryProtocol

    init(repository: TagRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Tag] {
        try await repository.fetchTags()
    }
}
