import Foundation

// MARK: - Protocol

/// Fetches all notes stored in the repository, unfiltered.
protocol GetNotesUseCaseProtocol {
    /// Fetches every note from the data source.
    /// - Returns: An array of ``Note`` values, possibly empty.
    /// - Throws: A repository error if the fetch operation fails.
    func execute() async throws -> [Note]
}

// MARK: - Implementation

/// Default implementation of ``GetNotesUseCaseProtocol`` backed by ``NoteRepositoryProtocol``.
final class GetNotesUseCase: GetNotesUseCaseProtocol {

    // MARK: - Properties

    private let repository: NoteRepositoryProtocol

    // MARK: - Initialization

    /// - Parameter repository: The data source to fetch notes from.
    init(repository: NoteRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Public Methods

    func execute() async throws -> [Note] {
        try await repository.fetchNotes()
    }
}
