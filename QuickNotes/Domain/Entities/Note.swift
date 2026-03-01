import Foundation

// MARK: - Note Entity

/// Represents a user-created note in the QuickNotes domain.
/// A note optionally belongs to one ``Category`` and can carry multiple ``Tag``s.
/// Notes can be pinned, archived, or marked completed to control their visibility in the list.
struct Note: Identifiable, Codable, Equatable {
    
    /// Stable unique identifier; generated automatically on creation.
    let id: UUID
    
    /// Title of the note
    let title: String
    
    /// Main content of the note
    let content: String

    /// Category associated with the note
    let category: Category?

    /// When true, the note is shown at the top of the list (pinned).
    let isPinned: Bool

    /// When true, the note is archived and hidden from the default list.
    let isArchived: Bool

    /// When true, the note is marked completed and hidden from the default list.
    let isCompleted: Bool

    /// Tags attached to this note; may be empty.
    let tags: [Tag]

    /// Date when the note was created
    let createdAt: Date
    
    /// Date when the note was last modified
    let modifiedAt: Date
}

// MARK: - Convenience Initializers

extension Note {
    
    /// Creates a new note with an auto-generated ``id`` and current timestamps for ``createdAt`` and ``modifiedAt``.
    /// - Parameters:
    ///   - title: Short headline for the note.
    ///   - content: Full body text of the note.
    ///   - category: Optional category to associate with the note; defaults to `nil`.
    ///   - isPinned: Whether the note should appear at the top of the list; defaults to `false`.
    ///   - isArchived: Whether the note is archived and hidden from the default list; defaults to `false`.
    ///   - isCompleted: Whether the note is marked as completed; defaults to `false`.
    ///   - tags: Tags to attach to the note; defaults to an empty array.
    init(title: String, content: String, category: Category? = nil, isPinned: Bool = false, isArchived: Bool = false, isCompleted: Bool = false, tags: [Tag] = []) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.category = category
        self.isPinned = isPinned
        self.isArchived = isArchived
        self.isCompleted = isCompleted
        self.tags = tags
        self.createdAt = Date()
        self.modifiedAt = Date()
    }
}