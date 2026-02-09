import Foundation
import SwiftData

// MARK: - SwiftDataNoteRepository

/// Note repository backed by SwiftData. Resolves category by ID when converting to domain Note.
final class SwiftDataNoteRepository: NoteRepositoryProtocol {

    private let container: ModelContainer
    private let categoryRepository: CategoryRepositoryProtocol

    init(container: ModelContainer, categoryRepository: CategoryRepositoryProtocol) {
        self.container = container
        self.categoryRepository = categoryRepository
    }

    func fetchNotes() async throws -> [Note] {
        let context = container.mainContext
        let descriptor = FetchDescriptor<NoteModel>(sortBy: [SortDescriptor(\.modifiedAt, order: .reverse)])
        let models = try context.fetch(descriptor)
        let categories = try await categoryRepository.fetchCategories()
        let categoryById = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })
        return models.map { $0.toNote(categoryById: categoryById) }
    }

    func fetchNote(id: UUID) async throws -> Note? {
        let context = container.mainContext
        var descriptor = FetchDescriptor<NoteModel>(predicate: #Predicate { $0.noteId == id })
        descriptor.fetchLimit = 1
        let models = try context.fetch(descriptor)
        guard let model = models.first else { return nil }
        let categories = try await categoryRepository.fetchCategories()
        let categoryById = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })
        return model.toNote(categoryById: categoryById)
    }

    func saveNote(_ note: Note) async throws {
        let context = container.mainContext
        var descriptor = FetchDescriptor<NoteModel>(predicate: #Predicate { $0.noteId == note.id })
        let existing = try context.fetch(descriptor)
        if let first = existing.first {
            first.title = note.title
            first.content = note.content
            first.categoryId = note.category?.id
            first.isPinned = note.isPinned
            first.modifiedAt = note.modifiedAt
        } else {
            let model = NoteModel.from(note)
            context.insert(model)
        }
        try context.save()
    }

    func updateNote(_ note: Note) async throws {
        try await saveNote(note)
    }

    func deleteNote(id: UUID) async throws {
        let context = container.mainContext
        var descriptor = FetchDescriptor<NoteModel>(predicate: #Predicate { $0.noteId == id })
        let models = try context.fetch(descriptor)
        for model in models {
            context.delete(model)
        }
        try context.save()
    }
}
