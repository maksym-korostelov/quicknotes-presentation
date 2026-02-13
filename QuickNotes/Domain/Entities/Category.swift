import Foundation

// MARK: - Category Entity

/// Represents a category that organizes notes in the QuickNotes app.
struct Category: Identifiable, Codable, Equatable, Hashable {
    
    /// Unique identifier for the category
    let id: UUID
    
    /// Display name of the category
    let name: String

    /// SF Symbol name for the category icon
    let icon: String

    /// Hex color string for category styling
    let colorHex: String
    
    /// Date when the category was created
    let createdAt: Date
    
    /// Date when the category was last modified
    let modifiedAt: Date
}

// MARK: - Convenience Initializers

extension Category {
    
    /// Creates a new category with auto-generated ID and current timestamps.
    init(name: String, icon: String = "folder", colorHex: String = "3B82F6") {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
        self.createdAt = Date()
        self.modifiedAt = Date()
    }
}
