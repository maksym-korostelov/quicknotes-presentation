import Foundation

// MARK: - Protocol

protocol AddCategoryUseCaseProtocol {
    func execute(category: Category) async throws
}

// MARK: - Implementation

final class AddCategoryUseCase: AddCategoryUseCaseProtocol {

    private let repository: CategoryRepositoryProtocol

    init(repository: CategoryRepositoryProtocol) {
        self.repository = repository
    }

    func execute(category: Category) async throws {
        try await repository.addCategory(category)
    }
}
