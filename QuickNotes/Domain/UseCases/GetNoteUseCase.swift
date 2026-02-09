import Foundation

// MARK: - Protocol

/// Protocol for fetching a single note by ID.
protocol GetNoteUseCaseProtocol {
    /// Fetches a note by ID.
    /// - Parameter id: The unique identifier of the note
    /// - Returns: The note if found, nil otherwise
    func execute(id: UUID) async throws -> Note?
}

// MARK: - Implementation

/// Use case for fetching a single note.
final class GetNoteUseCase: GetNoteUseCaseProtocol {

    private let repository: NoteRepositoryProtocol

    init(repository: NoteRepositoryProtocol) {
        self.repository = repository
    }

    func execute(id: UUID) async throws -> Note? {
        try await repository.fetchNote(id: id)
    }
}
