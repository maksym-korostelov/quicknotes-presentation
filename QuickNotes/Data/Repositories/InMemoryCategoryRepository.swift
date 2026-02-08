import Foundation

// MARK: - InMemoryCategoryRepository

/// Simple in-memory category repository for local demos.
final class InMemoryCategoryRepository: CategoryRepositoryProtocol {

    // MARK: - Properties

    private var categories: [Category]
    private let lock = NSLock()

    // MARK: - Initialization

    init(seedCategories: [Category] = []) {
        if seedCategories.isEmpty {
            self.categories = [
                Category(name: "Work", icon: "briefcase.fill", colorHex: "F59E0B"),
                Category(name: "Personal", icon: "person.fill", colorHex: "3B82F6"),
                Category(name: "Ideas", icon: "lightbulb.fill", colorHex: "10B981")
            ]
        } else {
            self.categories = seedCategories
        }
    }

    // MARK: - CategoryRepositoryProtocol

    func fetchCategories() async throws -> [Category] {
        lock.lock()
        defer { lock.unlock() }
        return categories.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    func fetchCategory(by id: UUID) async throws -> Category? {
        lock.lock()
        defer { lock.unlock() }
        return categories.first { $0.id == id }
    }

    func addCategory(_ category: Category) async throws {
        lock.lock()
        defer { lock.unlock() }
        categories.append(category)
    }

    func deleteCategory(by id: UUID) async throws {
        lock.lock()
        defer { lock.unlock() }
        categories.removeAll { $0.id == id }
    }
}
