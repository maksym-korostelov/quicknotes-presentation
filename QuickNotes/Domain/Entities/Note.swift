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
    
    /// Date when the note was created
    let createdAt: Date
    
    /// Date when the note was last modified
    let modifiedAt: Date
}

// MARK: - Convenience Initializers

extension Note {
    
    /// Creates a new note with auto-generated ID and current timestamps.
    init(title: String, content: String) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdAt = Date()
        self.modifiedAt = Date()
    }
}