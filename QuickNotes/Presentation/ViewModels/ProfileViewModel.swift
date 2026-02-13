import Foundation
import Observation

// MARK: - ProfileViewModel

@Observable
final class ProfileViewModel {

    // MARK: - Properties

    private(set) var profile: UserProfile?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let getNotesUseCase: GetNotesUseCaseProtocol
    private let getCategoriesUseCase: GetCategoriesUseCaseProtocol

    // MARK: - Initialization

    init(getNotesUseCase: GetNotesUseCaseProtocol, getCategoriesUseCase: GetCategoriesUseCaseProtocol) {
        self.getNotesUseCase = getNotesUseCase
        self.getCategoriesUseCase = getCategoriesUseCase
    }

    // MARK: - Actions

    @MainActor
    func loadProfile() async {
        isLoading = true
        errorMessage = nil
        do {
            let notes = try await getNotesUseCase.execute()
            let categories = try await getCategoriesUseCase.execute()
            profile = UserProfile(
                displayName: "Maksym",
                email: "maksym@quicknotes.app",
                joinedDate: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date(),
                notesCount: notes.count,
                categoriesCount: categories.count
            )
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
