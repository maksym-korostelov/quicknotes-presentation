---
applyTo: "**/Presentation/ViewModels/**"
---

# ViewModel Instructions

## Structure Rules
- ViewModels are `final` classes marked with `@Observable` macro (iOS 17+)
- ViewModel names follow pattern: `{Feature}ViewModel` (e.g., `NoteListViewModel`, `NoteDetailViewModel`)
- Each ViewModel lives in its own file
- ViewModels never import Data layer types or frameworks

## Dependency Injection
- Inject UseCases via constructor, NOT repositories directly
- Use protocol types for all dependencies
- Dependencies should be `private let` properties

## State Management
- Define published properties for View consumption (no `@Published` needed with `@Observable`)
- Include state properties: `isLoading`, `errorMessage`
- Consider using a `ViewState` enum for complex states:
  ```swift
  enum ViewState {
      case idle
      case loading
      case loaded
      case error(String)
  }
  ```

## Methods
- Mark methods that update UI state with `@MainActor`
- Use `async` for methods that call UseCases
- Handle errors gracefully and set `errorMessage` property
- Keep methods focused on presentation logic only

## Example Structure
```swift
import Foundation

@Observable
final class NoteListViewModel {
    // MARK: - Properties
    var notes: [Note] = []
    var isLoading = false
    var errorMessage: String?
    
    private let getNotesUseCase: GetNotesUseCaseProtocol
    private let deleteNoteUseCase: DeleteNoteUseCaseProtocol
    
    // MARK: - Initialization
    init(getNotesUseCase: GetNotesUseCaseProtocol,
         deleteNoteUseCase: DeleteNoteUseCaseProtocol) {
        self.getNotesUseCase = getNotesUseCase
        self.deleteNoteUseCase = deleteNoteUseCase
    }
    
    // MARK: - Methods
    @MainActor
    func loadNotes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            notes = try await getNotesUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    @MainActor
    func deleteNote(_ note: Note) async {
        do {
            try await deleteNoteUseCase.execute(noteId: note.id)
            notes.removeAll { $0.id == note.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
```

## Error Handling
- Always catch errors from UseCase calls
- Convert technical errors to user-friendly messages when appropriate
- Store error messages in `errorMessage` property for View display
- Clear `errorMessage` when starting new operations

## Best Practices
- Keep ViewModels testable (protocol-based dependencies)
- Don't perform business logic in ViewModels (delegate to UseCases)
- Avoid view-specific logic (frame calculations, colors, etc.)
- Use computed properties for derived state when appropriate