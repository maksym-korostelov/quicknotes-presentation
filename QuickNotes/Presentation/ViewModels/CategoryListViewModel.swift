import Foundation
import Observation

// MARK: - CategoryListViewModel

@Observable
final class CategoryListViewModel {

    // MARK: - Properties

    private(set) var categories: [Category] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let getCategoriesUseCase: GetCategoriesUseCase

    // MARK: - Initialization

    init(getCategoriesUseCase: GetCategoriesUseCase) {
        self.getCategoriesUseCase = getCategoriesUseCase
    }

    // MARK: - Actions

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
}
