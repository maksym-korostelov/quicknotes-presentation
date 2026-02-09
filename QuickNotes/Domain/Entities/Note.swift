import Foundation

// MARK: - Note Entity

/// Represents a user's note in the QuickNotes app.
struct Note: Identifiable, Codable, Equatable {
    
    /// Unique identifier for the note
    let id: UUID
    
    /// Title of the note
    let title: String
    
    /// Main content of the note
    let content: String

    /// Category associated with the note
    let category: Category?

    /// When true, the note is shown at the top of the list (pinned).
    let isPinned: Bool
    
    /// Date when the note was created
    let createdAt: Date
    
    /// Date when the note was last modified
    let modifiedAt: Date
}

// MARK: - Convenience Initializers

extension Note {
    
    /// Creates a new note with auto-generated ID and current timestamps.
    init(title: String, content: String, category: Category? = nil, isPinned: Bool = false) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.category = category
        self.isPinned = isPinned
        self.createdAt = Date()
        self.modifiedAt = Date()
    }
}