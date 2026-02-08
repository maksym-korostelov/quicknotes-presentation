import Foundation

// MARK: - InMemoryNoteRepository

/// Simple in-memory note repository for local demos.
final class InMemoryNoteRepository: NoteRepositoryProtocol {

    // MARK: - Properties

    private var notes: [Note]
    private let lock = NSLock()

    // MARK: - Initialization

    init(seedNotes: [Note] = []) {
        if seedNotes.isEmpty {
            self.notes = [
                Note(title: "Welcome to QuickNotes", content: "This is your first note. Tap + to create more!"),
                Note(title: "Shopping List", content: "Milk, Eggs, Bread, Butter"),
                Note(title: "Meeting Notes", content: "Discuss Q4 roadmap with the team")
            ]
        } else {
            self.notes = seedNotes
        }
    }

    // MARK: - NoteRepositoryProtocol

    func fetchNotes() async throws -> [Note] {
        lock.lock()
        defer { lock.unlock() }
        return notes.sorted { $0.modifiedAt > $1.modifiedAt }
    }

    func fetchNote(id: UUID) async throws -> Note? {
        lock.lock()
        defer { lock.unlock() }
        return notes.first { $0.id == id }
    }

    func saveNote(_ note: Note) async throws {
        lock.lock()
        defer { lock.unlock() }
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
        } else {
            notes.insert(note, at: 0)
        }
    }

    func updateNote(_ note: Note) async throws {
        lock.lock()
        defer { lock.unlock() }
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index] = note
        }
    }

    func deleteNote(id: UUID) async throws {
        lock.lock()
        defer { lock.unlock() }
        notes.removeAll { $0.id == id }
    }
}
