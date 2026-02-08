import SwiftUI

// MARK: - App Typography Design System
/// Centralized typography definitions using custom font family.
/// All views should use these tokens instead of raw `.font(...)` modifiers.
///
/// Migration mapping from system styles:
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

    static let displayLarge = Font.custom(fontFamily, size: 34, relativeTo: .largeTitle)
    static let displayMedium = Font.custom(fontFamily, size: 28, relativeTo: .title)

    // MARK: - Heading

    static let headingLarge = Font.custom(fontFamily, size: 22, relativeTo: .title2).weight(.semibold)
    static let headingMedium = Font.custom(fontFamily, size: 20, relativeTo: .title3).weight(.semibold)
    static let headingSmall = Font.custom(fontFamily, size: 17, relativeTo: .headline).weight(.semibold)

    // MARK: - Body

    static let bodyLarge = Font.custom(fontFamily, size: 17, relativeTo: .body)
    static let bodyMedium = Font.custom(fontFamily, size: 15, relativeTo: .subheadline)
    static let bodySmall = Font.custom(fontFamily, size: 13, relativeTo: .footnote)

    // MARK: - Caption

    static let captionLarge = Font.custom(fontFamily, size: 12, relativeTo: .caption)
    static let captionSmall = Font.custom(fontFamily, size: 11, relativeTo: .caption2)
}
