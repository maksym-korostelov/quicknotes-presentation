import Foundation
import Observation

// MARK: - SettingsViewModel

@Observable
final class SettingsViewModel {

    // MARK: - Properties

    var isDarkModeEnabled = false
    var isNotificationsEnabled = true
    var autoSaveInterval: Int = 30
    var defaultCategoryName: String = "General"
    var sortOrder: SortOrder = .dateDescending

    // MARK: - Sort Order

    enum SortOrder: String, CaseIterable, Identifiable {
        case dateAscending = "Date (Oldest First)"
        case dateDescending = "Date (Newest First)"
        case titleAscending = "Title (A-Z)"
        case titleDescending = "Title (Z-A)"

        var id: String { rawValue }
    }

    // MARK: - App Info

    var appVersion: String { "1.0.0" }
    var buildNumber: String { "1" }
}
