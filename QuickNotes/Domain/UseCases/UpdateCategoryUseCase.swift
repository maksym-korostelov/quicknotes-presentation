import Foundation

// MARK: - Protocol

/// Persists changes to an existing category in the data source.
protocol UpdateCategoryUseCaseProtocol {
    /// Saves the updated category, matching by ``Category/id``.
    /// - Parameter category: The category with updated fields to persist.
    /// - Throws: A repository error if the update fails.
    func execute(category: Category) async throws
}

// MARK: - Implementation

/// Default implementation of ``UpdateCategoryUseCaseProtocol`` backed by ``CategoryRepositoryProtocol``.
final class UpdateCategoryUseCase: UpdateCategoryUseCaseProtocol {

    private let repository: CategoryRepositoryProtocol

    /// - Parameter repository: The data source used to persist the updated category.
    init(repository: CategoryRepositoryProtocol) {
        self.repository = repository
    }

    func execute(category: Category) async throws {
        try await repository.updateCategory(category)
    }
}
