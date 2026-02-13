import Foundation

// MARK: - Protocol

protocol DeleteCategoryUseCaseProtocol {
    /// Deletes a category and unassigns it from all notes that used it.
    func execute(categoryId: UUID) async throws
}

// MARK: - Implementation

final class DeleteCategoryUseCase: DeleteCategoryUseCaseProtocol {

    private let categoryRepository: CategoryRepositoryProtocol
    private let getNotesUseCase: GetNotesUseCaseProtocol
    private let saveNoteUseCase: SaveNoteUseCaseProtocol

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
                createdAt: note.createdAt,
                modifiedAt: Date()
            )
            try await saveNoteUseCase.execute(note: updated)
        }
        try await categoryRepository.deleteCategory(by: categoryId)
    }
}
