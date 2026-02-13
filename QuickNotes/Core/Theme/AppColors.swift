import SwiftUI

// MARK: - App Semantic Text Colors
/// Centralized semantic text colors for typography and theming.
/// Use these tokens so behavior (e.g. dark mode, branding) can change in one place.
///
/// Exception: category-colored text uses the user-selected category color; no fixed token.

enum AppColors {

    // MARK: - General text

    /// Primary text (titles, main content).
    static let textPrimary = Color.primary

    /// Secondary text (metadata, hints, supporting content).
    static let textSecondary = Color.secondary

    /// Tertiary / caption text (muted, fine print).
    static let textTertiary = Color.secondary.opacity(0.9)

    /// Value text (selected option, version, build number).
    static let textValue = Color.secondary

    // MARK: - Actions and states

    /// Destructive action text (e.g. "Delete All Notes").
    static let textDestructive = Color.red

    /// Action / link text (e.g. "Import Notes", "Export Notes", "Privacy Policy").
    static let textAction = Color.accentColor

    // MARK: - Note status labels (Archived / Completed)

    /// Archived badge label.
    static let labelArchived = Color.gray

    /// Completed badge label.
    static let labelCompleted = Color.green

    /// Archived and completed badge label (both states).
    static let labelArchivedAndCompleted = Color.orange
}
