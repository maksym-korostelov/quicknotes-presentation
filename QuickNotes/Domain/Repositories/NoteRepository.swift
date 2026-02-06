import Foundation

/// Protocol defining operations for note data persistence.
protocol NoteRepository {
    /// Fetches all notes.
    /// - Returns: Array of all notes
    func getNotes() async throws -> [Note]
    
    /// Fetches a specific note by ID.
    /// - Parameter id: The unique identifier of the note
    /// - Returns: The note if found, nil otherwise
    func getNote(by id: UUID) async throws -> Note?
    
    /// Saves a new note or updates an existing one.
    /// - Parameter note: The note to save
    func saveNote(_ note: Note) async throws
    
    /// Deletes a note by ID.
    /// - Parameter id: The unique identifier of the note to delete
    func deleteNote(by id: UUID) async throws
}
