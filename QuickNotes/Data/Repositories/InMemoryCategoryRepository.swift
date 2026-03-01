import Foundation

// MARK: - InMemoryCategoryRepository

/// In-memory implementation of ``CategoryRepositoryProtocol``.
/// Stores categories in a simple array protected by an `NSLock`.
/// Intended for previews and local demos; data is not persisted between app launches.
final class InMemoryCategoryRepository: CategoryRepositoryProtocol {

    // MARK: - Properties

    private var categories: [Category]
    private let lock = NSLock()

    // MARK: - Initialization

    /// Creates the repository, optionally seeding it with known categories.
    /// - Parameter seedCategories: Initial categories to populate the store. If empty, a default
    ///   set of Work, Personal, and Ideas categories is used.
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

    /// Returns all categories sorted alphabetically by name.
    func fetchCategories() async throws -> [Category] {
        lock.lock()
        defer { lock.unlock() }
        return categories.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    /// Returns the category matching `id`, or `nil` if none exists.
    func fetchCategory(by id: UUID) async throws -> Category? {
        lock.lock()
        defer { lock.unlock() }
        return categories.first { $0.id == id }
    }

    /// Appends the category to the in-memory store.
    func addCategory(_ category: Category) async throws {
        lock.lock()
        defer { lock.unlock() }
        categories.append(category)
    }

    /// Replaces the stored category whose `id` matches `category.id`.
    func updateCategory(_ category: Category) async throws {
        lock.lock()
        defer { lock.unlock() }
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories[index] = category
        }
    }

    /// Removes the category with the given `id` from the in-memory store.
    func deleteCategory(by id: UUID) async throws {
        lock.lock()
        defer { lock.unlock() }
        categories.removeAll { $0.id == id }
    }
}
