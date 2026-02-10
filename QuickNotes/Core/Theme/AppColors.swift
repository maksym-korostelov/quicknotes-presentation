import SwiftUI

// MARK: - App Semantic Text Colors
/// Centralized semantic text colors for typography and theming.
/// Use these tokens so behavior (e.g. dark mode, branding) can change in one place.

enum AppColors {

    /// Primary text (titles, main content).
    static let textPrimary = Color.primary

    /// Secondary text (metadata, hints, supporting content).
    static let textSecondary = Color.secondary

    /// Tertiary / caption text (muted, fine print).
    static let textTertiary = Color.secondary.opacity(0.9)
}
