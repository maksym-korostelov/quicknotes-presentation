import Foundation

// MARK: - Protocol

/// Protocol for fetching all categories.
protocol GetCategoriesUseCaseProtocol {
    /// Fetches all categories.
    /// - Returns: An array of categories.
    /// - Throws: An error if the fetch operation fails.
    func execute() async throws -> [Category]
}

// MARK: - Implementation

/// Retrieves all available categories.
final class GetCategoriesUseCase: GetCategoriesUseCaseProtocol {

    // MARK: - Properties

    private let repository: CategoryRepositoryProtocol

    // MARK: - Initialization

    init(repository: CategoryRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Public Methods

    func execute() async throws -> [Category] {
        try await repository.fetchCategories()
    }
}
