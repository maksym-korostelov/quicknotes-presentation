---
applyTo: "**/*.swift"
---

# Code Generation Instructions

## File Placement

| Component | Path |
|-----------|------|
| Entities | `QuickNotes/QuickNotes/Domain/Entities/` |
| UseCases | `QuickNotes/QuickNotes/Domain/UseCases/` |
| Repository Protocols | `QuickNotes/QuickNotes/Domain/Repositories/` |
| Repository Implementations | `QuickNotes/QuickNotes/Data/Repositories/` |
| ViewModels | `QuickNotes/QuickNotes/Presentation/ViewModels/` |
| Views | `QuickNotes/QuickNotes/Presentation/Views/` |

## Swift Patterns

- Use `async/await` for asynchronous operations
- Use protocol + implementation pattern for UseCases and Repositories
- UseCases have a single `execute()` method
- Inject dependencies via initializer

## Code Organization

- Use `// MARK: -` comments: Properties, Initialization, Public Methods, Private Methods
- Add `///` documentation to all public types, properties, and methods