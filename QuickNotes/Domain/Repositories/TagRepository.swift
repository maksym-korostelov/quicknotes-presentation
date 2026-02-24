import Foundation

// MARK: - TagRepositoryProtocol

/// Protocol defining tag data operations.
protocol TagRepositoryProtocol {

    /// Fetches all available tags.
    func fetchTags() async throws -> [Tag]

    /// Adds a new tag to the store.
    func addTag(_ tag: Tag) async throws
}
