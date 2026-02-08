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
        noteRepository: NoteRepositoryProtocol = InMemoryNoteRepository(),
        categoryRepository: CategoryRepositoryProtocol = InMemoryCategoryRepository()
    ) {
        self.noteRepository = noteRepository
        self.categoryRepository = categoryRepository
        self.getNotesUseCase = GetNotesUseCase(repository: noteRepository)
        self.saveNoteUseCase = SaveNoteUseCase(repository: noteRepository)
        self.deleteNoteUseCase = DeleteNoteUseCase(repository: noteRepository)
        self.getCategoriesUseCase = GetCategoriesUseCase(repository: categoryRepository)
    }

    // MARK: - ViewModel Factories

    func makeNoteListViewModel() -> NoteListViewModel {
        NoteListViewModel(
            getNotesUseCase: getNotesUseCase,
            saveNoteUseCase: saveNoteUseCase,
            deleteNoteUseCase: deleteNoteUseCase
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
        NoteDetailViewModel(note: note, deleteNoteUseCase: deleteNoteUseCase)
    }

    func makeCategoryListViewModel() -> CategoryListViewModel {
        CategoryListViewModel(getCategoriesUseCase: getCategoriesUseCase)
    }
}
