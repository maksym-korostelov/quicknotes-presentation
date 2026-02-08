# QuickNotes - GitHub Copilot Instructions

## Additional Instruction Files

This project uses specialized instruction files for specific components. **Always follow these when creating or updating code:**

- **Entities:** See [`./instructions/entities.instructions.md`](./instructions/entities.instructions.md) when creating or updating entities
- **Code Generation:** See [`./instructions/code-generation.instructions.md`](./instructions/code-generation.instructions.md) when generating any Swift code
- **UseCases:** See [`./instructions/usecases.instructions.md`](./instructions/usecases.instructions.md) for UseCase protocol + implementation patterns
- **Repositories:** See [`./instructions/repositories.instructions.md`](./instructions/repositories.instructions.md) for domain and data layer repositories
- **ViewModels:** See [`./instructions/viewmodels.instructions.md`](./instructions/viewmodels.instructions.md) for @Observable ViewModels with UseCase injection
- **Unit Tests:** See [`./instructions/unit-tests.instructions.md`](./instructions/unit-tests.instructions.md) for test structure and mocking patterns

## Project Overview

QuickNotes is an iOS notes application built with SwiftUI following Clean Architecture principles.

- **Language:** Swift 5.9+
- **UI Framework:** SwiftUI
- **Minimum iOS:** 17.0
- **Architecture:** Clean Architecture

## Project Structure

```
QuickNotes/                          # Repository root
├── .github/                         # Copilot instructions
├── QuickNotes/                      # Source files (Xcode group)
│   ├── Presentation/
│   │   ├── Views/
│   │   └── ViewModels/
│   ├── Domain/
│   │   ├── Entities/
│   │   ├── UseCases/
│   │   └── Repositories/
│   ├── Data/
│   │   ├── Repositories/
│   │   └── DataSources/
│   └── Core/
└── QuickNotes.xcodeproj
```

> **IMPORTANT:** All source files go in `QuickNotes/QuickNotes/`, not the repository root.

## Architecture Rules

1. **Domain** has ZERO dependencies on other layers
2. **Presentation** depends only on Domain
3. **Data** depends only on Domain

## Coding Standards

### Entities

- Use `struct` with `let` properties
- Conform to `Identifiable`, `Codable`, `Equatable`
- Use `UUID` for identifiers
- Use `Date` for timestamps named `createdAt`, `modifiedAt`

### UseCases (IMPORTANT)

**Every UseCase MUST have both a Protocol and an Implementation:**

1. Define a protocol with suffix `Protocol` (e.g., `GetNotesUseCaseProtocol`)
2. Create a `final class` implementation conforming to the protocol
3. Single `execute()` method only
4. Inject dependencies via initializer
5. Use `async throws` for data operations

**UseCase Example (ALWAYS follow this pattern):**

```swift
import Foundation

// MARK: - Protocol

/// Protocol for fetching all notes.
protocol GetNotesUseCaseProtocol {
    /// Fetches all notes.
    /// - Returns: Array of notes
    func execute() async throws -> [Note]
}

// MARK: - Implementation

/// Fetches all notes from the repository.
final class GetNotesUseCase: GetNotesUseCaseProtocol {
    
    private let repository: NoteRepositoryProtocol
    
    init(repository: NoteRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Note] {
        try await repository.fetchAll()
    }
}
```

### ViewModels

- Use `@Observable` macro
- Use `private(set)` for state properties
- Inject UseCases via initializer (NOT repositories)
- Mark UI-updating methods with `@MainActor`

### Repository Protocols

- Define in `Domain/Repositories/`
- Name with suffix `Protocol` (e.g., `NoteRepositoryProtocol`)
- Use `async throws` for all methods

### Code Organization

- Use `// MARK: -` comments for sections: Protocol, Implementation, Properties, etc.
- Add `///` documentation to all public types and methods
- Order: Protocol first, then Implementation

## Naming Conventions

| Element | Convention | Example |
|---------|------------|---------|
| UseCase Protocol | Verb + Noun + UseCaseProtocol | `GetNotesUseCaseProtocol` |
| UseCase Implementation | Verb + Noun + UseCase | `GetNotesUseCase` |
| Repository Protocol | Noun + RepositoryProtocol | `NoteRepositoryProtocol` |
| Timestamps | `createdAt`, `modifiedAt` | NOT `createdDate` |

## Chat Communication Guidelines

- **Be concise:** Report only what matters in chat responses
- **Skip verbose details:** Don't explain every minor step
- **Offer explanations:** If something important needs clarification, suggest it to the user (e.g., "Need more details about X? 🤔")
- **Use emojis:** Add emojis frequently to make responses engaging and friendly 🎉✨
- **Focus on results:** Highlight what was accomplished, not how it was done unless asked