---
applyTo: "**/Domain/UseCases/**"
---

# UseCase Instructions

## Structure Rules
- Each UseCase has a single public `execute()` method
- UseCases are final classes with protocol-based dependency injection
- Constructor injection for all repository dependencies
- UseCase names follow pattern: `{Verb}{Noun}UseCase` (e.g., `GetNotesUseCase`, `DeleteNoteUseCase`)
- Each UseCase lives in its own file

## Protocol Pattern
- Define a protocol for each UseCase (e.g., `GetNotesUseCaseProtocol`) for testability
- Protocol defines only the `execute()` method signature
- Implementation class conforms to the protocol
- Mark implementation as `final class`

## Implementation Guidelines
- Use `async/await` for asynchronous operations
- Throw typed errors when appropriate
- Keep business logic focused and simple
- Delegate data access to repositories
- No direct data layer dependencies

## Example Structure
```swift
import Foundation

protocol GetNotesUseCaseProtocol {
    func execute() async throws -> [Note]
}

final class GetNotesUseCase: GetNotesUseCaseProtocol {
    private let repository: NoteRepositoryProtocol
    
    init(repository: NoteRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [Note] {
        return try await repository.fetchNotes()
    }
}
```

## Naming Conventions
- Protocol: `{UseCase}Protocol`
- Class: `{UseCase}`
- Method: `execute()` (with appropriate parameters and return type)
- Dependencies: injected via initializer as protocol types