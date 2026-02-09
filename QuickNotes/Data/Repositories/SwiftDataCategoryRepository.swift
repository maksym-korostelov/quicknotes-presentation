import Foundation
import SwiftData

// MARK: - SwiftDataCategoryRepository

/// Category repository backed by SwiftData.
final class SwiftDataCategoryRepository: CategoryRepositoryProtocol {

    private let container: ModelContainer

    init(container: ModelContainer) {
        self.container = container
    }

    func fetchCategories() async throws -> [Category] {
        let context = container.mainContext
        let descriptor = FetchDescriptor<CategoryModel>(sortBy: [SortDescriptor(\.name)])
        let models = try context.fetch(descriptor)
        return models.map { $0.toCategory() }
    }

    func fetchCategory(by id: UUID) async throws -> Category? {
        let context = container.mainContext
        var descriptor = FetchDescriptor<CategoryModel>(predicate: #Predicate { $0.categoryId == id })
        descriptor.fetchLimit = 1
        let models = try context.fetch(descriptor)
        return models.first?.toCategory()
    }

    func addCategory(_ category: Category) async throws {
        let context = container.mainContext
        let model = CategoryModel.from(category)
        context.insert(model)
        try context.save()
    }

    func deleteCategory(by id: UUID) async throws {
        let context = container.mainContext
        var descriptor = FetchDescriptor<CategoryModel>(predicate: #Predicate { $0.categoryId == id })
        let models = try context.fetch(descriptor)
        for model in models {
            context.delete(model)
        }
        try context.save()
    }
}
