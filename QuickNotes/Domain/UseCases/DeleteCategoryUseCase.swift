import Foundation

// MARK: - Protocol

/// Deletes a category and removes its association from every note that referenced it.
protocol DeleteCategoryUseCaseProtocol {
    /// Deletes a category and unassigns it from all notes that used it.
    /// - Parameter categoryId: The unique identifier of the category to delete.
    /// - Throws: A repository error if the delete or any note update fails.
    func execute(categoryId: UUID) async throws
}

// MARK: - Implementation

/// Default implementation of ``DeleteCategoryUseCaseProtocol``.
/// Fetches affected notes, clears their category reference, then deletes the category.
final class DeleteCategoryUseCase: DeleteCategoryUseCaseProtocol {

    private let categoryRepository: CategoryRepositoryProtocol
    private let getNotesUseCase: GetNotesUseCaseProtocol
    private let saveNoteUseCase: SaveNoteUseCaseProtocol

    /// - Parameter categoryRepository: The data source used to delete the category.
    /// - Parameter getNotesUseCase: Used to fetch notes that reference the category.
    /// - Parameter saveNoteUseCase: Used to persist notes after clearing their category.
    init(
        categoryRepository: CategoryRepositoryProtocol,
        getNotesUseCase: GetNotesUseCaseProtocol,
        saveNoteUseCase: SaveNoteUseCaseProtocol
    ) {
        self.categoryRepository = categoryRepository
        self.getNotesUseCase = getNotesUseCase
        self.saveNoteUseCase = saveNoteUseCase
    }

    func execute(categoryId: UUID) async throws {
        let notes = try await getNotesUseCase.execute()
        for note in notes where note.category?.id == categoryId {
            let updated = Note(
                id: note.id,
                title: note.title,
                content: note.content,
                category: nil,
                isPinned: note.isPinned,
                isArchived: note.isArchived,
                isCompleted: note.isCompleted,
                tags: note.tags,
                createdAt: note.createdAt,
                modifiedAt: Date()
            )
            try await saveNoteUseCase.execute(note: updated)
        }
        try await categoryRepository.deleteCategory(by: categoryId)
    }
}
