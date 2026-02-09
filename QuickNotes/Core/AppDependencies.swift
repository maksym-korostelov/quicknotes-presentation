import Foundation

// MARK: - AppDependencies

/// App-level dependency container for building view models.
final class AppDependencies {

    // MARK: - Repositories

    private let noteRepository: NoteRepositoryProtocol
    private let categoryRepository: CategoryRepositoryProtocol

    // MARK: - Use Cases

    let getNotesUseCase: GetNotesUseCaseProtocol
    let saveNoteUseCase: SaveNoteUseCaseProtocol
    let deleteNoteUseCase: DeleteNoteUseCaseProtocol
    let getCategoriesUseCase: GetCategoriesUseCaseProtocol

    // MARK: - Initialization

    init(
        noteRepository: NoteRepositoryProtocol? = nil,
        categoryRepository: CategoryRepositoryProtocol? = nil
    ) {
        let seedCategories = SeedData.defaultCategories
        let seedNotes = SeedData.defaultNotes(categories: seedCategories)
        self.noteRepository = noteRepository ?? InMemoryNoteRepository(seedNotes: seedNotes)
        self.categoryRepository = categoryRepository ?? InMemoryCategoryRepository(seedCategories: seedCategories)
        self.getNotesUseCase = GetNotesUseCase(repository: self.noteRepository)
        self.saveNoteUseCase = SaveNoteUseCase(repository: self.noteRepository)
        self.deleteNoteUseCase = DeleteNoteUseCase(repository: self.noteRepository)
        self.getCategoriesUseCase = GetCategoriesUseCase(repository: self.categoryRepository)
    }

    // MARK: - ViewModel Factories

    func makeNoteListViewModel(initialCategoryFilter: UUID? = nil) -> NoteListViewModel {
        NoteListViewModel(
            getNotesUseCase: getNotesUseCase,
            getCategoriesUseCase: getCategoriesUseCase,
            saveNoteUseCase: saveNoteUseCase,
            deleteNoteUseCase: deleteNoteUseCase,
            initialCategoryFilter: initialCategoryFilter
        )
    }

    func makeNoteEditorViewModel(note: Note? = nil) -> NoteEditorViewModel {
        NoteEditorViewModel(
            note: note,
            saveNoteUseCase: saveNoteUseCase,
            getCategoriesUseCase: getCategoriesUseCase
        )
    }

    func makeNoteDetailViewModel(note: Note) -> NoteDetailViewModel {
        NoteDetailViewModel(note: note, deleteNoteUseCase: deleteNoteUseCase, saveNoteUseCase: saveNoteUseCase)
    }

    func makeCategoryListViewModel() -> CategoryListViewModel {
        CategoryListViewModel(getCategoriesUseCase: getCategoriesUseCase)
    }

    func makeProfileViewModel() -> ProfileViewModel {
        ProfileViewModel(
            getNotesUseCase: getNotesUseCase,
            getCategoriesUseCase: getCategoriesUseCase
        )
    }
}
