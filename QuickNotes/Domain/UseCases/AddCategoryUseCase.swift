import Foundation

// MARK: - Protocol

/// Persists a new category to the data source.
protocol AddCategoryUseCaseProtocol {
    /// Adds the given category to the repository.
    /// - Parameter category: The new category to persist.
    /// - Throws: A repository error if the write fails.
    func execute(category: Category) async throws
}

// MARK: - Implementation

/// Default implementation of ``AddCategoryUseCaseProtocol`` backed by ``CategoryRepositoryProtocol``.
final class AddCategoryUseCase: AddCategoryUseCaseProtocol {

    private let repository: CategoryRepositoryProtocol

    /// - Parameter repository: The data source used to persist the new category.
    init(repository: CategoryRepositoryProtocol) {
        self.repository = repository
    }

    func execute(category: Category) async throws {
        try await repository.addCategory(category)
    }
}
