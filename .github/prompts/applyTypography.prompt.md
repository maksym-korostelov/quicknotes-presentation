---
name: applyTypography
description: Migrate system fonts to custom AppTypography design system tokens
argument-hint: file path or #file reference to migrate
---
Migrate all font definitions in the specified file to use the AppTypography design system based on the mapping rules defined in `AppTypography.swift`.

**Instructions:**
1. Review the file and identify all font and foregroundStyle usages
2. Apply the mapping rules from AppTypography.swift:
   - `.largeTitle` → `AppTypography.displayLarge`
   - `.title` → `AppTypography.displayMedium`
   - `.title2` → `AppTypography.headingLarge`
   - `.title3` → `AppTypography.headingMedium`
   - `.headline` → `AppTypography.headingSmall`
   - `.body` → `AppTypography.bodyLarge`
   - `.subheadline` → `AppTypography.bodyMedium`
   - `.footnote` → `AppTypography.bodySmall`
   - `.caption` → `AppTypography.captionLarge`
   - `.caption2` → `AppTypography.captionSmall`
3. Replace `.font()` and `.foregroundStyle()` with `.appTypography(_:colorOverride:)`
4. Use semantic typography tokens when appropriate:
   - Action links → `bodyLargeAction` (blue)
   - Destructive actions → `bodyLargeDestructive` (red)
   - Value text → `bodyMediumValue` (gray)
   - Hints/descriptions → `bodySmallHint` (light gray)
   - Hero icons → `iconHeroLarge`, `iconHeroXLarge`, `iconHeroXXLarge`, or `iconHeroMedium`
   - Status labels → `labelArchived`, `labelCompleted`, `labelArchivedCompleted`
5. Use `colorOverride` parameter when the color differs from the token's default
6. Preserve all other modifiers and layout properties

**Example transformation:**
```swift
// Before
Text("Title")
    .font(.title3)
    .fontWeight(.semibold)

Text("Description")
    .font(.body)
    .foregroundStyle(.secondary)

// After
Text("Title")
    .appTypography(AppTypography.headingMedium)

Text("Description")
    .appTypography(AppTypography.bodyLarge, colorOverride: AppColors.textSecondary)
```

Apply all migrations and ensure no compilation errors remain.