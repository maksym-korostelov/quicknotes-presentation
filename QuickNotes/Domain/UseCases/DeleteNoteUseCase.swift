import Foundation

// MARK: - Protocol

/// Protocol for deleting a note.
protocol DeleteNoteUseCaseProtocol {
    /// Deletes a note by its ID.
    /// - Parameter id: The unique identifier of the note to delete
    func execute(id: UUID) async throws
}

// MARK: - Implementation

/// Deletes a note from the repository.
final class DeleteNoteUseCase: DeleteNoteUseCaseProtocol {
    
    // MARK: - Properties
    
    private let repository: NoteRepositoryProtocol
    
    // MARK: - Initialization
    
    /// Initializes the use case with a note repository.
    /// - Parameter repository: The repository to delete notes from
    init(repository: NoteRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    
    func execute(id: UUID) async throws {
        try await repository.deleteNote(id: id)
    }
}
