import Foundation
import Observation

// MARK: - NoteDetailViewModel

@Observable
final class NoteDetailViewModel {

    // MARK: - Properties

    private(set) var note: Note
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let deleteNoteUseCase: DeleteNoteUseCaseProtocol

    // MARK: - Initialization

    init(note: Note, deleteNoteUseCase: DeleteNoteUseCaseProtocol) {
        self.note = note
        self.deleteNoteUseCase = deleteNoteUseCase
    }

    // MARK: - Actions

    @MainActor
    func deleteNote() async {
        isLoading = true
        errorMessage = nil
        do {
            try await deleteNoteUseCase.execute(id: note.id)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    /// Clears the current error message (e.g. after user dismisses alert).
    func clearError() {
        errorMessage = nil
    }
}
