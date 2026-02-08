import Foundation

/// Use case for fetching all notes.
final class GetNotesUseCase {
    private let repository: NoteRepository
    
    /// Initializes the use case with a note repository.
    /// - Parameter repository: The repository to fetch notes from
    init(repository: NoteRepository) {
        self.repository = repository
    }
    
    /// Executes the use case to fetch all notes.
    /// - Returns: Array of all notes
    func execute() async throws -> [Note] {
        try await repository.getNotes()
    }
}
