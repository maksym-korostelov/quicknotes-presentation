import Foundation
import SwiftData

// MARK: - CategoryModel

/// SwiftData persistence model for Category. Maps to domain `Category`.
@Model
final class CategoryModel {

    var categoryId: UUID
    var name: String
    var icon: String
    var colorHex: String
    var createdAt: Date
    var modifiedAt: Date

    init(categoryId: UUID, name: String, icon: String, colorHex: String, createdAt: Date, modifiedAt: Date) {
        self.categoryId = categoryId
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }

    /// Converts to domain entity. Category uses synthesized memberwise init (id, name, icon, colorHex, createdAt, modifiedAt).
    func toCategory() -> Category {
        Category(
            id: categoryId,
            name: name,
            icon: icon,
            colorHex: colorHex,
            createdAt: createdAt,
            modifiedAt: modifiedAt
        )
    }

    /// Creates a model from a domain entity.
    static func from(_ category: Category) -> CategoryModel {
        CategoryModel(
            categoryId: category.id,
            name: category.name,
            icon: category.icon,
            colorHex: category.colorHex,
            createdAt: category.createdAt,
            modifiedAt: category.modifiedAt
        )
    }
}
