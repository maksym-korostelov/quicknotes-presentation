import Foundation
import Observation

// MARK: - CategoryEditorViewModel

/// ViewModel for the category editor sheet (`CategoryEditorView`).
/// Supports both creating a new category and editing an existing one.
@Observable
final class CategoryEditorViewModel {

    /// Current value of the category name text field.
    var name: String
    /// SF Symbol name selected by the user for the category icon.
    var selectedIcon: String
    /// Hex color string currently selected for the category.
    var selectedColorHex: String
    /// `true` while a save operation is in flight.
    private(set) var isLoading = false
    /// `true` once the category has been successfully saved; used to dismiss the sheet.
    private(set) var isSaved = false
    /// Non-nil when the last save attempt failed; contains a human-readable description.
    private(set) var errorMessage: String?

    private let addCategoryUseCase: AddCategoryUseCaseProtocol
    private let updateCategoryUseCase: UpdateCategoryUseCaseProtocol
    private let existingCategory: Category?

    /// Predefined icon choices available to the user, each as a display name and its SF Symbol identifier.
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

    /// Predefined color choices available to the user, each as a display label and its hex string.
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

    /// Creates the ViewModel, pre-populating fields when editing an existing category.
    /// - Parameter existingCategory: The category to edit, or `nil` when creating a new one.
    /// - Parameter addCategoryUseCase: Used to persist the category when creating.
    /// - Parameter updateCategoryUseCase: Used to persist the category when editing.
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

    /// `true` when the ViewModel was initialized with an existing category.
    var isEditing: Bool { existingCategory != nil }

    /// `true` when the current name contains at least one non-whitespace character.
    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Validates the form and saves the category using either the add or update use case.
    /// Sets ``isLoading`` while in flight, ``isSaved`` on success, and ``errorMessage`` on failure.
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

    /// Clears the current ``errorMessage``, allowing the UI to reset any error state.
    func clearError() {
        errorMessage = nil
    }
}
