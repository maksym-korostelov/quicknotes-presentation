---
applyTo: "**/Domain/Entities/**"
---

# Entity Instructions

## Structure

- Use `struct` for value semantics
- Use `let` for all properties (immutability)
- Conform to `Identifiable`, `Codable`, `Equatable`

## Properties

- Use `UUID` for identifiers
- Use `Date` for timestamps
- Name timestamps as `createdAt`, `modifiedAt`

## Example

```swift
import Foundation

// MARK: - Note Entity

/// Represents a user's note.
struct Note: Identifiable, Codable, Equatable {
    
    /// Unique identifier
    let id: UUID
    
    /// Note title
    let title: String
    
    /// Note content
    let content: String
    
    /// Creation timestamp
    let createdAt: Date
    
    /// Last modification timestamp
    let modifiedAt: Date
}
```