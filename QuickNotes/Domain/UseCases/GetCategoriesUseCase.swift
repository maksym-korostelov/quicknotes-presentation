import Foundation

// MARK: - GetCategoriesUseCase

/// Retrieves all available categories.
final class GetCategoriesUseCase {

    // MARK: - Dependencies

    private let repository: CategoryRepositoryProtocol

    // MARK: - Initialization

    init(repository: CategoryRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Execution

    /// Fetches all categories.
    /// - Returns: An array of categories.
    /// - Throws: An error if the fetch operation fails.
    func execute() async throws -> [Category] {
        try await repository.fetchCategories()
    }
}
