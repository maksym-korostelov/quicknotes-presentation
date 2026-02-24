import Foundation

// MARK: - InMemoryTagRepository

/// Simple in-memory tag repository for local demos.
final class InMemoryTagRepository: TagRepositoryProtocol {

    // MARK: - Properties

    private var tags: [Tag] = []
    private let lock = NSLock()

    // MARK: - Initialization

    init() {}

    // MARK: - TagRepositoryProtocol

    func fetchTags() async throws -> [Tag] {
        lock.lock()
        defer { lock.unlock() }
        return tags.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    func addTag(_ tag: Tag) async throws {
        lock.lock()
        defer { lock.unlock() }
        tags.append(tag)
    }
}
