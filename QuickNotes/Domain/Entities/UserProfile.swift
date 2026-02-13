import Foundation

// MARK: - UserProfile Entity

struct UserProfile: Identifiable, Hashable {

    // MARK: - Properties

    let id: UUID
    var displayName: String
    var email: String
    var avatarURL: URL?
    var joinedDate: Date
    var notesCount: Int
    var categoriesCount: Int

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        displayName: String,
        email: String,
        avatarURL: URL? = nil,
        joinedDate: Date = Date(),
        notesCount: Int = 0,
        categoriesCount: Int = 0
    ) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.avatarURL = avatarURL
        self.joinedDate = joinedDate
        self.notesCount = notesCount
        self.categoriesCount = categoriesCount
    }
}
