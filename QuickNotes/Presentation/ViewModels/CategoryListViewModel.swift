import Foundation
import Observation

// MARK: - CategoryListViewModel

@Observable
final class CategoryListViewModel {

    private(set) var categories: [Category] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let getCategoriesUseCase: GetCategoriesUseCaseProtocol
    private let addCategoryUseCase: AddCategoryUseCaseProtocol
    private let updateCategoryUseCase: UpdateCategoryUseCaseProtocol
    private let deleteCategoryUseCase: DeleteCategoryUseCaseProtocol

    init(
        getCategoriesUseCase: GetCategoriesUseCaseProtocol,
        addCategoryUseCase: AddCategoryUseCaseProtocol,
        updateCategoryUseCase: UpdateCategoryUseCaseProtocol,
        deleteCategoryUseCase: DeleteCategoryUseCaseProtocol
    ) {
        self.getCategoriesUseCase = getCategoriesUseCase
        self.addCategoryUseCase = addCategoryUseCase
        self.updateCategoryUseCase = updateCategoryUseCase
        self.deleteCategoryUseCase = deleteCategoryUseCase
    }

    @MainActor
    func loadCategories() async {
        isLoading = true
        errorMessage = nil
        do {
            categories = try await getCategoriesUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    func deleteCategory(id: UUID) async {
        isLoading = true
        errorMessage = nil
        do {
            try await deleteCategoryUseCase.execute(categoryId: id)
            categories.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func clearError() {
        errorMessage = nil
    }
}
