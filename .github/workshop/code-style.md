# QuickNotes iOS — Swift Code Style Guidelines

This document is a reference for the GitHub Copilot Workshop Assistant. It contains Swift/iOS code style rules for the QuickNotes project.

---

## Naming Conventions

- **Types**: PascalCase — `NoteListViewModel`, `GetNotesUseCase`
- **Properties/Methods**: camelCase — `fetchNotes()`, `noteTitle`
- **Protocols**: Descriptive name — `NoteRepositoryProtocol` or `NoteRepository`

## Code Structure

- Use `// MARK: -` comments to organize code sections
- Keep files focused on single responsibility
- Use extensions to organize protocol conformances

## SwiftUI Patterns

- Use `@Observable` macro for ViewModels (iOS 17+)
- Prefer `@State`, `@Binding` for view-local state
- Use dependency injection via initializers

## Design System Usage

```swift
// Typography with default color
Text("Title")
    .appTypography(AppTypography.headingLarge)

// Typography with color override
Text("Subtitle")
    .appTypography(AppTypography.bodyMedium, colorOverride: AppColors.textSecondary)

// Font only (no color change)
Text("Plain")
    .font(AppTypography.bodyLarge.font)

// Semantic colors
Text("Delete")
    .foregroundColor(AppColors.textDestructive)
```

## Clean Architecture Patterns

### UseCases

```swift
final class GetNotesUseCase {
    private let repository: NoteRepositoryProtocol

    init(repository: NoteRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> [Note] {
        try await repository.fetchAll()
    }
}
```

### Entities

```swift
// Plain Swift struct, no framework dependencies
struct Note: Identifiable, Equatable {
    let id: UUID
    var title: String
    var content: String
    var category: Category?
    var createdAt: Date
    var updatedAt: Date
}
```

### Repository Protocol

```swift
protocol NoteRepositoryProtocol {
    func fetchAll() async throws -> [Note]
    func save(_ note: Note) async throws
    func delete(_ note: Note) async throws
}
```

### Data Models

```swift
// @Model class in Data/Models for SwiftData persistence
@Model
final class NoteModel {
    var id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date

    // Map to Domain Entity
    func toDomain() -> Note {
        Note(id: id, title: title, content: content, createdAt: createdAt, updatedAt: updatedAt)
    }
}
```

### ViewModel

```swift
@Observable
final class NoteListViewModel {
    private let getNotesUseCase: GetNotesUseCase

    var notes: [Note] = []
    var isLoading = false
    var errorMessage: String?

    init(getNotesUseCase: GetNotesUseCase) {
        self.getNotesUseCase = getNotesUseCase
    }

    func fetchNotes() async {
        isLoading = true
        do {
            notes = try await getNotesUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
```
