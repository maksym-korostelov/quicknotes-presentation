import Foundation

// MARK: - Protocol

/// Protocol for fetching all notes.
protocol GetNotesUseCaseProtocol {
    /// Fetches all notes.
    /// - Returns: Array of all notes
    func execute() async throws -> [Note]
}

// MARK: - Implementation

/// Use case for fetching all notes.
final class GetNotesUseCase: GetNotesUseCaseProtocol {

    // MARK: - Properties

    private let repository: NoteRepositoryProtocol

    // MARK: - Initialization

    /// Initializes the use case with a note repository.
    /// - Parameter repository: The repository to fetch notes from
    init(repository: NoteRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Public Methods

    func execute() async throws -> [Note] {
        try await repository.fetchNotes()
    }
}
