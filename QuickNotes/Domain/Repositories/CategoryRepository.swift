import Foundation

// MARK: - CategoryRepository Protocol

/// Defines the contract for category data access.
/// Implementation resides in the Data layer.
protocol CategoryRepositoryProtocol {

    /// Fetches all available categories.
    /// - Returns: An array of categories sorted by name.
    /// - Throws: An error if the fetch operation fails.
    func fetchCategories() async throws -> [Category]

    /// Fetches a single category by its identifier.
    /// - Parameter id: The unique identifier of the category.
    /// - Returns: The matching category, or nil if not found.
    /// - Throws: An error if the fetch operation fails.
    func fetchCategory(by id: UUID) async throws -> Category?

    /// Adds a new category.
    /// - Parameter category: The category to add.
    /// - Throws: An error if the add operation fails.
    func addCategory(_ category: Category) async throws

    /// Deletes a category by its identifier.
    /// - Parameter id: The unique identifier of the category to delete.
    /// - Throws: An error if the delete operation fails.
    func deleteCategory(by id: UUID) async throws
}
