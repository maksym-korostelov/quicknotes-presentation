import Foundation
import Observation

// MARK: - NoteEditorViewModel

@Observable
final class NoteEditorViewModel {

    // MARK: - Properties

    var title: String
    var content: String
    var selectedCategory: Category?
    var isPinned: Bool
    var selectedTags: [Tag] = []
    private(set) var isLoading = false
    private(set) var isSaved = false
    private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let saveNoteUseCase: SaveNoteUseCaseProtocol
    private let getCategoriesUseCase: GetCategoriesUseCaseProtocol
    private let getTagsUseCase: GetTagsUseCaseProtocol
    private let addTagUseCase: AddTagUseCaseProtocol
    private(set) var categories: [Category] = []
    private(set) var availableTags: [Tag] = []
    private let existingNote: Note?

    // MARK: - Initialization

    init(
        note: Note? = nil,
        saveNoteUseCase: SaveNoteUseCaseProtocol,
        getCategoriesUseCase: GetCategoriesUseCaseProtocol,
        getTagsUseCase: GetTagsUseCaseProtocol,
        addTagUseCase: AddTagUseCaseProtocol
    ) {
        self.existingNote = note
        self.title = note?.title ?? ""
        self.content = note?.content ?? ""
        self.selectedCategory = note?.category
        self.isPinned = note?.isPinned ?? false
        self.selectedTags = note?.tags ?? []
        self.saveNoteUseCase = saveNoteUseCase
        self.getCategoriesUseCase = getCategoriesUseCase
        self.getTagsUseCase = getTagsUseCase
        self.addTagUseCase = addTagUseCase
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
    func loadTags() async {
        do {
            availableTags = try await getTagsUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    func createAndSelectTag(name: String, colorHex: String) async {
        do {
            let tag = try await addTagUseCase.execute(name: name, colorHex: colorHex)
            availableTags.append(tag)
            availableTags.sort { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            selectedTags.append(tag)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggleTag(_ tag: Tag) {
        if let index = selectedTags.firstIndex(of: tag) {
            selectedTags.remove(at: index)
        } else {
            selectedTags.append(tag)
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
                isPinned: isPinned,
                isArchived: existingNote?.isArchived ?? false,
                isCompleted: existingNote?.isCompleted ?? false,
                tags: selectedTags,
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
