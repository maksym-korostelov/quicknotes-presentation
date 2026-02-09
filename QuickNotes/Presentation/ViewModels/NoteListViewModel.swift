import Foundation
import Observation

// MARK: - NoteListViewModel

/// ViewModel for the notes list screen.
@Observable
final class NoteListViewModel {
    
    // MARK: - Properties
    
    /// List of notes to display (all fetched notes)
    private(set) var notes: [Note] = []
    
    /// Currently selected category filter (nil = show all).
    var selectedCategoryId: UUID?
    
    /// Notes to display after applying category filter and sort.
    var filteredNotes: [Note] {
        guard let categoryId = selectedCategoryId else { return notes }
        return notes.filter { $0.category?.id == categoryId }
    }
    
    /// Categories for the filter picker (loaded from use case).
    private(set) var categories: [Category] = []
    
    /// Loading state indicator
    private(set) var isLoading = false
    
    /// Error message if something goes wrong
    private(set) var errorMessage: String?
    
    // MARK: - Dependencies

    private let getNotesUseCase: GetNotesUseCaseProtocol
    private let getCategoriesUseCase: GetCategoriesUseCaseProtocol
    private let saveNoteUseCase: SaveNoteUseCaseProtocol
    private let deleteNoteUseCase: DeleteNoteUseCaseProtocol

    // MARK: - Initialization

    init(
        getNotesUseCase: GetNotesUseCaseProtocol,
        getCategoriesUseCase: GetCategoriesUseCaseProtocol,
        saveNoteUseCase: SaveNoteUseCaseProtocol,
        deleteNoteUseCase: DeleteNoteUseCaseProtocol,
        initialCategoryFilter: UUID? = nil
    ) {
        self.getNotesUseCase = getNotesUseCase
        self.getCategoriesUseCase = getCategoriesUseCase
        self.saveNoteUseCase = saveNoteUseCase
        self.deleteNoteUseCase = deleteNoteUseCase
        self.selectedCategoryId = initialCategoryFilter
    }

    // MARK: - Public Methods

    /// Loads notes for display, sorted by the given order.
    @MainActor
    func loadNotes(sortOrder: SettingsViewModel.SortOrder = .dateDescending) async {
        isLoading = true
        errorMessage = nil
        do {
            let fetched = try await getNotesUseCase.execute()
            notes = Self.sort(fetched, by: sortOrder)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    /// Loads categories for the filter picker.
    @MainActor
    func loadCategories() async {
        do {
            categories = try await getCategoriesUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private static func sort(_ notes: [Note], by order: SettingsViewModel.SortOrder) -> [Note] {
        switch order {
        case .dateAscending:
            return notes.sorted { $0.modifiedAt < $1.modifiedAt }
        case .dateDescending:
            return notes.sorted { $0.modifiedAt > $1.modifiedAt }
        case .titleAscending:
            return notes.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .titleDescending:
            return notes.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedDescending }
        }
    }

    /// Adds a new note to the list.
    @MainActor
    func addNote(title: String, content: String) async {
        isLoading = true
        errorMessage = nil
        do {
            let note = Note(title: title, content: content)
            try await saveNoteUseCase.execute(note: note)
            let fetched = try await getNotesUseCase.execute()
            notes = Self.sort(fetched, by: .dateDescending)
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

    /// Clears the current error message (e.g. after user dismisses alert).
    func clearError() {
        errorMessage = nil
    }
}
