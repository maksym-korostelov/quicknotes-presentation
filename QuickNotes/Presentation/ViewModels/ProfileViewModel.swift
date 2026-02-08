import Foundation
import Observation

// MARK: - ProfileViewModel

@Observable
final class ProfileViewModel {

    // MARK: - Properties

    private(set) var profile: UserProfile?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // MARK: - Initialization

    init() {
        // Load a sample profile for demo purposes
        self.profile = UserProfile(
            displayName: "Maksym",
            email: "maksym@quicknotes.app",
            joinedDate: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date(),
            notesCount: 42,
            categoriesCount: 7
        )
    }
}
