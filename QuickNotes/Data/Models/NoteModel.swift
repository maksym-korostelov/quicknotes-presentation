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
    /// Optional so existing stores (created before this attribute) can load; nil is treated as false.
    var isArchived: Bool?
    /// Optional so existing stores (created before this attribute) can load; nil is treated as false.
    var isCompleted: Bool?

    var createdAt: Date
    var modifiedAt: Date
    /// JSON-encoded `[Tag]` array. Optional for backward compatibility with existing stores.
    var tagsJSON: String?

    init(noteId: UUID, title: String, content: String, categoryId: UUID?, isPinned: Bool, isArchived: Bool?, isCompleted: Bool?, tagsJSON: String? = nil, createdAt: Date, modifiedAt: Date) {
        self.noteId = noteId
        self.title = title
        self.content = content
        self.categoryId = categoryId
        self.isPinned = isPinned
        self.isArchived = isArchived
        self.isCompleted = isCompleted
        self.tagsJSON = tagsJSON
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }

    /// Converts to domain entity using the given category lookup.
    func toNote(categoryById: [UUID: Category]) -> Note {
        let category = categoryId.flatMap { categoryById[$0] }
        let tags: [Tag]
        if let json = tagsJSON, let data = json.data(using: .utf8),
           let decoded = try? JSONDecoder().decode([Tag].self, from: data) {
            tags = decoded
        } else {
            tags = []
        }
        return Note(
            id: noteId,
            title: title,
            content: content,
            category: category,
            isPinned: isPinned,
            isArchived: isArchived ?? false,
            isCompleted: isCompleted ?? false,
            tags: tags,
            createdAt: createdAt,
            modifiedAt: modifiedAt
        )
    }

    /// Creates a model from a domain entity.
    static func from(_ note: Note) -> NoteModel {
        let tagsJSON = (try? JSONEncoder().encode(note.tags)).flatMap { String(data: $0, encoding: .utf8) }
        return NoteModel(
            noteId: note.id,
            title: note.title,
            content: note.content,
            categoryId: note.category?.id,
            isPinned: note.isPinned,
            isArchived: note.isArchived,
            isCompleted: note.isCompleted,
            tagsJSON: tagsJSON,
            createdAt: note.createdAt,
            modifiedAt: note.modifiedAt
        )
    }
}
