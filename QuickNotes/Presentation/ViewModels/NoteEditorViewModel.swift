import Foundation
import Observation

// MARK: - NoteEditorViewModel

@Observable
final class NoteEditorViewModel {

    // MARK: - Properties

    var title: String
    var content: String
    var selectedCategory: Category?
    private(set) var isLoading = false
    private(set) var isSaved = false
    private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let saveNoteUseCase: SaveNoteUseCaseProtocol
    private let getCategoriesUseCase: GetCategoriesUseCaseProtocol
    private(set) var categories: [Category] = []
    private let existingNote: Note?

    // MARK: - Initialization

    init(
        note: Note? = nil,
        saveNoteUseCase: SaveNoteUseCaseProtocol,
        getCategoriesUseCase: GetCategoriesUseCaseProtocol
    ) {
        self.existingNote = note
        self.title = note?.title ?? ""
        self.content = note?.content ?? ""
        self.selectedCategory = note?.category
        self.saveNoteUseCase = saveNoteUseCase
        self.getCategoriesUseCase = getCategoriesUseCase
    }

    // MARK: - Actions

    @MainActor
    func loadCategories() async {
        do {
            categories = try await getCategoriesUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func save() async {
        isLoading = true
        errorMessage = nil
        do {
            let note = Note(
                id: existingNote?.id ?? UUID(),
                title: title,
                content: content,
                category: selectedCategory,
                createdAt: existingNote?.createdAt ?? Date(),
                modifiedAt: Date()
            )
            try await saveNoteUseCase.execute(note: note)
            isSaved = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Clears the current error message (e.g. after user dismisses alert).
    func clearError() {
        errorMessage = nil
    }
}
