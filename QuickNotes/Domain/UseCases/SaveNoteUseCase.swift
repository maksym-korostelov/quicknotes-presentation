import Foundation

// MARK: - Protocol

/// Protocol for saving a note.
protocol SaveNoteUseCaseProtocol {
    /// Saves the given note. Creates a new note or updates an existing one.
    /// - Parameter note: The note to save.
    /// - Throws: An error if validation fails or the save operation fails.
    func execute(note: Note) async throws
}

// MARK: - Implementation

/// Default implementation of ``SaveNoteUseCaseProtocol``.
/// Validates that the note title is non-empty before delegating persistence to ``NoteRepositoryProtocol``.
final class SaveNoteUseCase: SaveNoteUseCaseProtocol {

    // MARK: - Properties

    private let repository: NoteRepositoryProtocol

    // MARK: - Initialization

    /// - Parameter repository: The data source used to persist the note.
    init(repository: NoteRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Public Methods

    func execute(note: Note) async throws {
        guard !note.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw SaveNoteError.emptyTitle
        }
        try await repository.saveNote(note)
    }
}

// MARK: - SaveNoteError

/// Errors that can be thrown by ``SaveNoteUseCase``.
enum SaveNoteError: LocalizedError {
    /// The note's title is blank or contains only whitespace.
    case emptyTitle

    var errorDescription: String? {
        switch self {
        case .emptyTitle:
            return "Note title cannot be empty."
        }
    }
}
