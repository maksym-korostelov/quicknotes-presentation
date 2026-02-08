---
applyTo: "**/Repositories/**"
---

# Repository Instructions

## Protocol Definition (Domain Layer)
- Repository protocols live in `Domain/Repositories/`
- Protocol names end with `Protocol` suffix (e.g., `NoteRepositoryProtocol`)
- Define all CRUD operations the domain needs
- Use `async/await` patterns for asynchronous operations
- Use domain entities as parameter and return types, NOT data layer models
- Each repository protocol lives in its own file

## Method Naming
- **Fetch single:** `fetch{Entity}(id:) async throws -> Entity?`
- **Fetch multiple:** `fetch{Entities}() async throws -> [Entity]`
- **Save:** `save{Entity}(_ entity:) async throws`
- **Update:** `update{Entity}(_ entity:) async throws`
- **Delete:** `delete{Entity}(id:) async throws`

## Implementation (Data Layer)
- Repository implementations live in `Data/Repositories/`
- Implementation names match protocol without `Protocol` suffix
- Implementations coordinate between Local and Remote DataSources
- Handle data mapping between DTOs and Domain Entities
- Implement caching strategies when applicable
- Mark implementations as `final class`

## Error Handling
- Define domain-specific error types (e.g., `enum NoteRepositoryError: Error`)
- Map data layer errors to domain errors
- Never expose data layer error types to domain
- Provide meaningful error messages

## Example Protocol Structure
```swift
import Foundation

protocol NoteRepositoryProtocol {
    func fetchNotes() async throws -> [Note]
    func fetchNote(id: UUID) async throws -> Note?
    func saveNote(_ note: Note) async throws
    func updateNote(_ note: Note) async throws
    func deleteNote(id: UUID) async throws
}
```

## Dependencies
- Protocols: Import only Foundation
- Implementations: Can import data layer frameworks (CoreData, Realm, etc.)
- Never import UI frameworks (SwiftUI, UIKit) in repositories