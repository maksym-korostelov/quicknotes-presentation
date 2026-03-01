import Foundation
import Observation

// MARK: - CategoryListViewModel

/// ViewModel for the category management screen (`CategoryListView`).
/// Owns the full list of categories and coordinates load and delete operations.
@Observable
final class CategoryListViewModel {

    /// All categories currently loaded from the repository, sorted alphabetically.
    private(set) var categories: [Category] = []
    /// `true` while any async operation (load or delete) is in flight.
    private(set) var isLoading = false
    /// Non-nil when the last operation failed; contains a human-readable description.
    private(set) var errorMessage: String?

    private let getCategoriesUseCase: GetCategoriesUseCaseProtocol
    private let addCategoryUseCase: AddCategoryUseCaseProtocol
    private let updateCategoryUseCase: UpdateCategoryUseCaseProtocol
    private let deleteCategoryUseCase: DeleteCategoryUseCaseProtocol

    /// - Parameter getCategoriesUseCase: Fetches all categories from the repository.
    /// - Parameter addCategoryUseCase: Persists a newly created category.
    /// - Parameter updateCategoryUseCase: Persists changes to an existing category.
    /// - Parameter deleteCategoryUseCase: Removes a category and unlinks it from notes.
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

    /// Fetches all categories from the repository and refreshes ``categories``.
    /// Sets ``isLoading`` while in flight and populates ``errorMessage`` on failure.
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

    /// Deletes the category with the given `id` and removes it from ``categories``.
    /// Sets ``isLoading`` while in flight and populates ``errorMessage`` on failure.
    /// - Parameter id: The unique identifier of the category to delete.
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

    /// Clears the current ``errorMessage``, allowing the UI to reset any error state.
    func clearError() {
        errorMessage = nil
    }
}
