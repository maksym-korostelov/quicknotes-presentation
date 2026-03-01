import Foundation

// MARK: - Protocol

/// Permanently removes a note from the repository by its identifier.
protocol DeleteNoteUseCaseProtocol {
    /// Deletes the note with the given identifier.
    /// - Parameter id: The unique identifier of the note to delete.
    /// - Throws: A repository error if no matching note exists or the delete operation fails.
    func execute(id: UUID) async throws
}

// MARK: - Implementation

/// Default implementation of ``DeleteNoteUseCaseProtocol`` backed by ``NoteRepositoryProtocol``.
final class DeleteNoteUseCase: DeleteNoteUseCaseProtocol {
    
    // MARK: - Properties
    
    private let repository: NoteRepositoryProtocol
    
    // MARK: - Initialization
    
    /// - Parameter repository: The data source from which the note will be removed.
    init(repository: NoteRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    
    func execute(id: UUID) async throws {
        try await repository.deleteNote(id: id)
    }
}
