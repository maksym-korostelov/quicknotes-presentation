import Foundation

// MARK: - Protocol

protocol UpdateCategoryUseCaseProtocol {
    func execute(category: Category) async throws
}

// MARK: - Implementation

final class UpdateCategoryUseCase: UpdateCategoryUseCaseProtocol {

    private let repository: CategoryRepositoryProtocol

    init(repository: CategoryRepositoryProtocol) {
        self.repository = repository
    }

    func execute(category: Category) async throws {
        try await repository.updateCategory(category)
    }
}
