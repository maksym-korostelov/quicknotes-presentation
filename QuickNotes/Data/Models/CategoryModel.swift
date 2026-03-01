import Foundation
import SwiftData

// MARK: - CategoryModel

/// SwiftData persistence model for Category. Maps to domain `Category`.
@Model
final class CategoryModel {

    /// Stable unique identifier matching ``Category/id``.
    var categoryId: UUID
    /// Display name of the category.
    var name: String
    /// SF Symbol name used for the category icon.
    var icon: String
    /// Hex color string used for category styling.
    var colorHex: String
    /// Date when the category was originally created.
    var createdAt: Date
    /// Date when the category was last modified.
    var modifiedAt: Date

    /// Creates a new model with all fields explicitly provided.
    /// - Parameters:
    ///   - categoryId: The UUID matching the domain entity's identifier.
    ///   - name: Display name of the category.
    ///   - icon: SF Symbol name for the category icon.
    ///   - colorHex: Hex color string for category styling.
    ///   - createdAt: Original creation timestamp.
    ///   - modifiedAt: Last modification timestamp.
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
