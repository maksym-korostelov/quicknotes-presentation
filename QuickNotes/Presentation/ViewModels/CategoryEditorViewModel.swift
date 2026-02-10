import Foundation
import Observation

// MARK: - CategoryEditorViewModel

@Observable
final class CategoryEditorViewModel {

    var name: String
    var selectedIcon: String
    var selectedColorHex: String
    private(set) var isLoading = false
    private(set) var isSaved = false
    private(set) var errorMessage: String?

    private let addCategoryUseCase: AddCategoryUseCaseProtocol
    private let updateCategoryUseCase: UpdateCategoryUseCaseProtocol
    private let existingCategory: Category?

    static let availableIcons: [(name: String, sfSymbol: String)] = [
        ("Folder", "folder.fill"),
        ("Briefcase", "briefcase.fill"),
        ("Person", "person.fill"),
        ("Lightbulb", "lightbulb.fill"),
        ("Heart", "heart.fill"),
        ("Star", "star.fill"),
        ("Tag", "tag.fill"),
        ("Book", "book.fill"),
        ("House", "house.fill"),
        ("Envelope", "envelope.fill"),
        ("Camera", "camera.fill"),
        ("Music", "music.note"),
        ("Sport", "sportscourt.fill"),
        ("Cart", "cart.fill"),
        ("Gift", "gift.fill"),
    ]

    static let availableColors: [(label: String, hex: String)] = [
        ("Blue", "3B82F6"),
        ("Green", "10B981"),
        ("Amber", "F59E0B"),
        ("Red", "EF4444"),
        ("Purple", "8B5CF6"),
        ("Pink", "EC4899"),
        ("Indigo", "6366F1"),
        ("Teal", "14B8A6"),
        ("Orange", "F97316"),
        ("Gray", "6B7280"),
    ]

    init(
        existingCategory: Category? = nil,
        addCategoryUseCase: AddCategoryUseCaseProtocol,
        updateCategoryUseCase: UpdateCategoryUseCaseProtocol
    ) {
        self.existingCategory = existingCategory
        self.addCategoryUseCase = addCategoryUseCase
        self.updateCategoryUseCase = updateCategoryUseCase
        self.name = existingCategory?.name ?? ""
        self.selectedIcon = existingCategory?.icon ?? "folder.fill"
        self.selectedColorHex = existingCategory?.colorHex ?? "3B82F6"
    }

    var isEditing: Bool { existingCategory != nil }

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    @MainActor
    func save() async {
        guard isValid else { return }
        isLoading = true
        errorMessage = nil
        do {
            if let existing = existingCategory {
                let updated = Category(
                    id: existing.id,
                    name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                    icon: selectedIcon,
                    colorHex: selectedColorHex,
                    createdAt: existing.createdAt,
                    modifiedAt: Date()
                )
                try await updateCategoryUseCase.execute(category: updated)
            } else {
                let category = Category(
                    name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                    icon: selectedIcon,
                    colorHex: selectedColorHex
                )
                try await addCategoryUseCase.execute(category: category)
            }
            isSaved = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func clearError() {
        errorMessage = nil
    }
}
