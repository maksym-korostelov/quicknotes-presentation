import Foundation

/// Protocol defining operations for note data persistence.
protocol NoteRepositoryProtocol {
    /// Fetches all notes.
    /// - Returns: Array of all notes
    func fetchNotes() async throws -> [Note]

    /// Fetches a specific note by ID.
    /// - Parameter id: The unique identifier of the note
    /// - Returns: The note if found, nil otherwise
    func fetchNote(id: UUID) async throws -> Note?

    /// Saves a new note.
    /// - Parameter note: The note to save
    func saveNote(_ note: Note) async throws

    /// Updates an existing note.
    /// - Parameter note: The note to update
    func updateNote(_ note: Note) async throws

    /// Deletes a note by ID.
    /// - Parameter id: The unique identifier of the note to delete
    func deleteNote(id: UUID) async throws
}
