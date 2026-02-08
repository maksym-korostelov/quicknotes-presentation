---
applyTo: "**/*Tests*/**"
---

# Unit Test Instructions

## File Organization
- Test files live in `QuickNotesTests/` directory
- Mirror source file structure (e.g., `Domain/UseCases/GetNotesUseCase.swift` → `QuickNotesTests/Domain/UseCases/GetNotesUseCaseTests.swift`)
- One test class per source class

## Naming Conventions
- **Test files:** `{ClassName}Tests.swift`
- **Test classes:** `final class {ClassName}Tests: XCTestCase`
- **Test methods:** `test_{methodName}_{scenario}_{expectedResult}()`
- **Examples:**
  - `test_execute_withValidData_returnsNotes()`
  - `test_execute_withEmptyRepository_returnsEmptyArray()`
  - `test_execute_whenRepositoryFails_throwsError()`

## Test Structure (Arrange-Act-Assert)
Use `// MARK:` comments to organize test classes:
```swift
final class GetNotesUseCaseTests: XCTestCase {
    // MARK: - Properties
    private var sut: GetNotesUseCase!
    private var mockRepository: MockNoteRepository!
    
    // MARK: - Setup
    override func setUp() {
        super.setUp()
        mockRepository = MockNoteRepository()
        sut = GetNotesUseCase(repository: mockRepository)
    }
    
    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }
    
    // MARK: - Success Cases
    func test_execute_withValidData_returnsNotes() async throws {
        // Arrange
        let expectedNotes = [Note(...)]
        mockRepository.notesToReturn = expectedNotes
        
        // Act
        let result = try await sut.execute()
        
        // Assert
        XCTAssertEqual(result.count, expectedNotes.count)
        XCTAssertEqual(mockRepository.fetchNotesCallCount, 1)
    }
    
    // MARK: - Failure Cases
    // ...
    
    // MARK: - Edge Cases
    // ...
}
```

## Mocking Pattern
- Create mock classes conforming to protocol dependencies
- Place mocks in `QuickNotesTests/Mocks/` folder for reusability
- Or define mocks within test file for simple cases
- Use properties to control mock behavior (return values, errors to throw)
- Track method calls for verification (call count, passed arguments)

## Mock Example
```swift
final class MockNoteRepository: NoteRepositoryProtocol {
    var notesToReturn: [Note] = []
    var errorToThrow: Error?
    var fetchNotesCallCount = 0
    var deleteNoteCallCount = 0
    var lastDeletedNoteId: UUID?
    
    func fetchNotes() async throws -> [Note] {
        fetchNotesCallCount += 1
        if let error = errorToThrow {
            throw error
        }
        return notesToReturn
    }
    
    func deleteNote(id: UUID) async throws {
        deleteNoteCallCount += 1
        lastDeletedNoteId = id
        if let error = errorToThrow {
            throw error
        }
    }
    
    // Implement other protocol methods...
}
```

## Test Coverage Requirements
- **Minimum per UseCase:** success case, failure case, edge case
- **Minimum per ViewModel:** initial state, loading state, loaded state, error state
- **Minimum per Repository:** all CRUD operations with success and failure scenarios

## Async Testing
- Use `async throws` for test methods when testing async code
- Use `await` for async operations
- Use `XCTAssertThrowsError` or `do-catch` with `XCTFail()` for error testing

## Assertions
- Use descriptive failure messages: `XCTAssertEqual(result, expected, "Notes should match expected values")`
- Test both positive and negative conditions
- Verify mock interactions (call counts, parameters)