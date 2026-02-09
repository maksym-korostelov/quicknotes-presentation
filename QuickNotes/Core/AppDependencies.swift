import Foundation
import SwiftData

// MARK: - AppDependencies

/// App-level dependency container for building view models.
final class AppDependencies {

    // MARK: - Repositories

    private let noteRepository: NoteRepositoryProtocol
    private let categoryRepository: CategoryRepositoryProtocol

    // MARK: - Use Cases

    let getNotesUseCase: GetNotesUseCaseProtocol
    let getNoteUseCase: GetNoteUseCaseProtocol
    let saveNoteUseCase: SaveNoteUseCaseProtocol
    let deleteNoteUseCase: DeleteNoteUseCaseProtocol
    let getCategoriesUseCase: GetCategoriesUseCaseProtocol

    // MARK: - Initialization

    init(
        noteRepository: NoteRepositoryProtocol? = nil,
        categoryRepository: CategoryRepositoryProtocol? = nil,
        modelContainer: ModelContainer? = nil
    ) {
        if let noteRepo = noteRepository, let categoryRepo = categoryRepository {
            self.noteRepository = noteRepo
            self.categoryRepository = categoryRepo
        } else if let container = modelContainer ?? Self.createDefaultContainer() {
            self.categoryRepository = SwiftDataCategoryRepository(container: container)
            self.noteRepository = SwiftDataNoteRepository(container: container, categoryRepository: self.categoryRepository)
        } else {
            let seedCategories = SeedData.defaultCategories
            let seedNotes = SeedData.defaultNotes(categories: seedCategories)
            self.categoryRepository = InMemoryCategoryRepository(seedCategories: seedCategories)
            self.noteRepository = InMemoryNoteRepository(seedNotes: seedNotes)
        }
        self.getNotesUseCase = GetNotesUseCase(repository: self.noteRepository)
        self.getNoteUseCase = GetNoteUseCase(repository: self.noteRepository)
        self.saveNoteUseCase = SaveNoteUseCase(repository: self.noteRepository)
        self.deleteNoteUseCase = DeleteNoteUseCase(repository: self.noteRepository)
        self.getCategoriesUseCase = GetCategoriesUseCase(repository: self.categoryRepository)
    }

    private static func createDefaultContainer() -> ModelContainer? {
        try? ModelContainer(for: NoteModel.self, CategoryModel.self)
    }

    /// Seeds default categories and notes if the store is empty. Call once at launch when using SwiftData.
    func seedIfNeeded() async {
        do {
            let notes = try await getNotesUseCase.execute()
            guard notes.isEmpty else { return }
            for category in SeedData.defaultCategories {
                try await categoryRepository.addCategory(category)
            }
            let categories = try await getCategoriesUseCase.execute()
            for note in SeedData.defaultNotes(categories: categories) {
                try await saveNoteUseCase.execute(note: note)
            }
        } catch {
            // Ignore seed errors (e.g. already seeded)
        }
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
        NoteDetailViewModel(
            note: note,
            getNoteUseCase: getNoteUseCase,
            deleteNoteUseCase: deleteNoteUseCase,
            saveNoteUseCase: saveNoteUseCase
        )
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
