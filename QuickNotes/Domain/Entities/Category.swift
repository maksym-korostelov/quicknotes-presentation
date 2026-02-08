import Foundation

// MARK: - Category Entity

/// Represents a category that organizes notes in the QuickNotes app.
struct Category: Identifiable, Codable, Equatable {
    
    /// Unique identifier for the category
    let id: UUID
    
    /// Title of the category
    let title: String
    
    /// Notes belonging to this category
    let notes: [Note]
    
    /// Date when the category was created
    let createdAt: Date
    
    /// Date when the category was last modified
    let modifiedAt: Date
}

// MARK: - Convenience Initializers

extension Category {
    
    /// Creates a new category with auto-generated ID, current timestamps, and empty notes array.
    init(title: String) {
        self.id = UUID()
        self.title = title
        self.notes = []
        self.createdAt = Date()
        self.modifiedAt = Date()
    }
    
    /// Creates a new category with auto-generated ID, current timestamps, and specified notes.
    init(title: String, notes: [Note]) {
        self.id = UUID()
        self.title = title
        self.notes = notes
        self.createdAt = Date()
        self.modifiedAt = Date()
    }
}
