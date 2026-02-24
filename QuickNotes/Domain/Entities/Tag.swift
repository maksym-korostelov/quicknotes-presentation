import Foundation

// MARK: - Tag Entity

/// Represents a tag that can be applied to notes.
struct Tag: Identifiable, Codable, Equatable, Hashable {

    /// Unique identifier for the tag
    let id: UUID

    /// Display name of the tag
    let name: String

    /// Hex color string for tag styling
    let colorHex: String

    /// Date when the tag was created
    let createdAt: Date

    /// Date when the tag was last modified
    let modifiedAt: Date
}

// MARK: - Convenience Initializers

extension Tag {

    /// Creates a new tag with auto-generated ID and current timestamps.
    init(name: String, colorHex: String = "3B82F6") {
        self.id = UUID()
        self.name = name
        self.colorHex = colorHex
        self.createdAt = Date()
        self.modifiedAt = Date()
    }
}
