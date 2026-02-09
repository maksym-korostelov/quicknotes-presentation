import Foundation
import SwiftData

// MARK: - NoteModel

/// SwiftData persistence model for Note. Maps to domain `Note`. Category is stored by ID and resolved when converting to `Note`.
@Model
final class NoteModel {

    var noteId: UUID
    var title: String
    var content: String
    var categoryId: UUID?
    var isPinned: Bool
    var createdAt: Date
    var modifiedAt: Date

    init(noteId: UUID, title: String, content: String, categoryId: UUID?, isPinned: Bool, createdAt: Date, modifiedAt: Date) {
        self.noteId = noteId
        self.title = title
        self.content = content
        self.categoryId = categoryId
        self.isPinned = isPinned
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }

    /// Converts to domain entity using the given category lookup.
    func toNote(categoryById: [UUID: Category]) -> Note {
        let category = categoryId.flatMap { categoryById[$0] }
        return Note(
            id: noteId,
            title: title,
            content: content,
            category: category,
            isPinned: isPinned,
            createdAt: createdAt,
            modifiedAt: modifiedAt
        )
    }

    /// Creates a model from a domain entity.
    static func from(_ note: Note) -> NoteModel {
        NoteModel(
            noteId: note.id,
            title: note.title,
            content: note.content,
            categoryId: note.category?.id,
            isPinned: note.isPinned,
            createdAt: note.createdAt,
            modifiedAt: note.modifiedAt
        )
    }
}
