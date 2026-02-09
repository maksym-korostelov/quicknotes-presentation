import Foundation
import Observation

// MARK: - NoteDetailViewModel

@Observable
final class NoteDetailViewModel {

    // MARK: - Properties

    var note: Note
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let getNoteUseCase: GetNoteUseCaseProtocol
    private let deleteNoteUseCase: DeleteNoteUseCaseProtocol
    private let saveNoteUseCase: SaveNoteUseCaseProtocol

    // MARK: - Initialization

    init(
        note: Note,
        getNoteUseCase: GetNoteUseCaseProtocol,
        deleteNoteUseCase: DeleteNoteUseCaseProtocol,
        saveNoteUseCase: SaveNoteUseCaseProtocol
    ) {
        self.note = note
        self.getNoteUseCase = getNoteUseCase
        self.deleteNoteUseCase = deleteNoteUseCase
        self.saveNoteUseCase = saveNoteUseCase
    }

    // MARK: - Actions

    /// Refreshes the note from the repository (e.g. after returning from the editor).
    @MainActor
    func refreshNote() async {
        do {
            if let updated = try await getNoteUseCase.execute(id: note.id) {
                note = updated
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func togglePin() async {
        isLoading = true
        errorMessage = nil
        do {
            let updated = Note(
                id: note.id,
                title: note.title,
                content: note.content,
                category: note.category,
                isPinned: !note.isPinned,
                isArchived: note.isArchived,
                isCompleted: note.isCompleted,
                createdAt: note.createdAt,
                modifiedAt: Date()
            )
            try await saveNoteUseCase.execute(note: updated)
            note = updated
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    func toggleArchive() async {
        isLoading = true
        errorMessage = nil
        do {
            let updated = Note(
                id: note.id,
                title: note.title,
                content: note.content,
                category: note.category,
                isPinned: note.isPinned,
                isArchived: !note.isArchived,
                isCompleted: note.isCompleted,
                createdAt: note.createdAt,
                modifiedAt: Date()
            )
            try await saveNoteUseCase.execute(note: updated)
            note = updated
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    func toggleCompleted() async {
        isLoading = true
        errorMessage = nil
        do {
            let updated = Note(
                id: note.id,
                title: note.title,
                content: note.content,
                category: note.category,
                isPinned: note.isPinned,
                isArchived: note.isArchived,
                isCompleted: !note.isCompleted,
                createdAt: note.createdAt,
                modifiedAt: Date()
            )
            try await saveNoteUseCase.execute(note: updated)
            note = updated
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

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
