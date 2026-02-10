import SwiftUI

// MARK: - App Typography Style
/// A full typography token: font (size + weight) and default text color.
/// Apply via `.appTypography(_:colorOverride:)` to set both font and foregroundStyle.
struct AppTypographyStyle {
    let font: Font
    let color: Color
}

// MARK: - App Typography Design System
/// Centralized typography definitions using custom font family and semantic colors.
/// All views can use these tokens with `.appTypography(_:colorOverride:)` for font + color.
///
/// Every token has at least one unique parameter (size, weight, or color). Exception: category-colored
/// text uses the user-selected category color via `colorOverride`, not a fixed typography color.
///
/// Mapping from system styles:
///   .largeTitle    → AppTypography.displayLarge
///   .title         → AppTypography.displayMedium
///   .title2        → AppTypography.headingLarge
///   .title3        → AppTypography.headingMedium
///   .headline      → AppTypography.headingSmall
///   .body          → AppTypography.bodyLarge
///   .subheadline   → AppTypography.bodyMedium
///   .footnote      → AppTypography.bodySmall
///   .caption       → AppTypography.captionLarge
///   .caption2      → AppTypography.captionSmall
///   .system(size: N) → closest AppTypography token by size

enum AppTypography {

    // MARK: - Font Family

    private static let fontFamily = "Helvetica Neue"

    // MARK: - Display

    static let displayLarge = AppTypographyStyle(
        font: .custom(fontFamily, size: 34, relativeTo: .largeTitle),
        color: AppColors.textPrimary
    )

    // MARK: - Icon hero (large decorative SF Symbols; system font for scaling)

    /// Large hero icon (e.g. About header). 64pt, blue.
    static let iconHeroLarge = AppTypographyStyle(
        font: .system(size: 64),
        color: AppColors.textAction
    )
    /// Extra-large hero icon (e.g. Onboarding). 72pt, blue.
    static let iconHeroXLarge = AppTypographyStyle(
        font: .system(size: 72),
        color: AppColors.textAction
    )
    /// Largest hero icon (e.g. Profile). 80pt, blue.
    static let iconHeroXXLarge = AppTypographyStyle(
        font: .system(size: 80),
        color: AppColors.textAction
    )
    /// Medium hero icon for empty states. 48pt, secondary.
    static let iconHeroMedium = AppTypographyStyle(
        font: .system(size: 48),
        color: AppColors.textSecondary
    )
    static let displayMedium = AppTypographyStyle(
        font: .custom(fontFamily, size: 28, relativeTo: .title),
        color: AppColors.textPrimary
    )

    // MARK: - Heading

    static let headingLarge = AppTypographyStyle(
        font: .custom(fontFamily, size: 22, relativeTo: .title2).weight(.semibold),
        color: AppColors.textPrimary
    )
    static let headingMedium = AppTypographyStyle(
        font: .custom(fontFamily, size: 20, relativeTo: .title3).weight(.semibold),
        color: AppColors.textPrimary
    )
    static let headingSmall = AppTypographyStyle(
        font: .custom(fontFamily, size: 17, relativeTo: .headline).weight(.semibold),
        color: AppColors.textPrimary
    )

    // MARK: - Body

    static let bodyLarge = AppTypographyStyle(
        font: .custom(fontFamily, size: 17, relativeTo: .body),
        color: AppColors.textPrimary
    )
    static let bodyMedium = AppTypographyStyle(
        font: .custom(fontFamily, size: 15, relativeTo: .subheadline),
        color: AppColors.textPrimary
    )
    static let bodySmall = AppTypographyStyle(
        font: .custom(fontFamily, size: 13, relativeTo: .footnote),
        color: AppColors.textPrimary
    )

    // MARK: - Caption

    static let captionLarge = AppTypographyStyle(
        font: .custom(fontFamily, size: 12, relativeTo: .caption),
        color: AppColors.textSecondary
    )
    static let captionSmall = AppTypographyStyle(
        font: .custom(fontFamily, size: 11, relativeTo: .caption2),
        color: AppColors.textSecondary
    )

    // MARK: - Semantic by color (body size)

    /// Destructive action (e.g. "Delete All Notes"). Body size, red.
    static let bodyLargeDestructive = AppTypographyStyle(
        font: .custom(fontFamily, size: 17, relativeTo: .body),
        color: AppColors.textDestructive
    )
    /// Action / link (e.g. "Import Notes", "Export Notes", "Privacy Policy"). Body size, accent blue.
    static let bodyLargeAction = AppTypographyStyle(
        font: .custom(fontFamily, size: 17, relativeTo: .body),
        color: AppColors.textAction
    )
    /// Value text (e.g. version, build, picker value). Subheadline size, gray.
    static let bodyMediumValue = AppTypographyStyle(
        font: .custom(fontFamily, size: 15, relativeTo: .subheadline),
        color: AppColors.textValue
    )
    /// Hint / description (e.g. "Manage how QuickNotes sends you notifications"). Footnote size, light gray.
    static let bodySmallHint = AppTypographyStyle(
        font: .custom(fontFamily, size: 13, relativeTo: .footnote),
        color: AppColors.textSecondary
    )

    // MARK: - Note status labels (unique by color)

    /// Archived badge on note row.
    static let labelArchived = AppTypographyStyle(
        font: .custom(fontFamily, size: 11, relativeTo: .caption2),
        color: AppColors.labelArchived
    )
    /// Completed badge on note row.
    static let labelCompleted = AppTypographyStyle(
        font: .custom(fontFamily, size: 11, relativeTo: .caption2),
        color: AppColors.labelCompleted
    )
    /// Archived and completed badge (both states).
    static let labelArchivedCompleted = AppTypographyStyle(
        font: .custom(fontFamily, size: 11, relativeTo: .caption2),
        color: AppColors.labelArchivedAndCompleted
    )
}

// MARK: - View Modifier

extension View {

    /// Applies the given typography style: font and foreground color.
    /// - Parameters:
    ///   - style: The typography style (font + default color).
    ///   - colorOverride: Optional color to use instead of the style’s default color.
    func appTypography(_ style: AppTypographyStyle, colorOverride: Color? = nil) -> some View {
        font(style.font)
            .foregroundStyle(colorOverride ?? style.color)
    }
}
