import Foundation
import Observation

// MARK: - NoteListViewModel

/// ViewModel for the notes list screen.
@Observable
final class NoteListViewModel {
    
    // MARK: - Properties
    
    /// List of notes to display
    private(set) var notes: [Note] = []
    
    /// Loading state indicator
    private(set) var isLoading = false
    
    /// Error message if something goes wrong
    private(set) var errorMessage: String?
    
    // MARK: - Dependencies

    private let getNotesUseCase: GetNotesUseCaseProtocol
    private let saveNoteUseCase: SaveNoteUseCaseProtocol
    private let deleteNoteUseCase: DeleteNoteUseCaseProtocol

    // MARK: - Initialization

    init(
        getNotesUseCase: GetNotesUseCaseProtocol,
        saveNoteUseCase: SaveNoteUseCaseProtocol,
        deleteNoteUseCase: DeleteNoteUseCaseProtocol
    ) {
        self.getNotesUseCase = getNotesUseCase
        self.saveNoteUseCase = saveNoteUseCase
        self.deleteNoteUseCase = deleteNoteUseCase
    }

    // MARK: - Public Methods

    /// Loads notes for display.
    @MainActor
    func loadNotes() async {
        isLoading = true
        errorMessage = nil
        do {
            notes = try await getNotesUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    /// Adds a new note to the list.
    @MainActor
    func addNote(title: String, content: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let note = Note(title: title, content: content)
            try await saveNoteUseCase.execute(note: note)
            notes = try await getNotesUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    /// Deletes a note by its ID.
    @MainActor
    func deleteNote(id: UUID) async {
        isLoading = true
        errorMessage = nil
        do {
            try await deleteNoteUseCase.execute(id: id)
            notes.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
