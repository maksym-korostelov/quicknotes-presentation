# QuickNotes iOS — Architecture Reference

This document is a reference for the GitHub Copilot Workshop Assistant. It contains the full iOS architecture overview, folder structure, and architecture rules for the QuickNotes project.

---

## Project Overview

A Notes application built progressively throughout the workshop series using **Clean Architecture**. The app exists in two platform implementations (iOS and Android) that mirror each other's architecture.

## Folder Structure

```
QuickNotes/
├── Presentation/
│   ├── Views/              # SwiftUI views
│   └── ViewModels/         # Presentation logic, intermediaries between Views and UseCases
├── Domain/
│   ├── Entities/           # Core business models (Note, Category, UserProfile)
│   ├── UseCases/           # Business rules (GetNotes, SaveNote, DeleteNote, GetCategories, etc.)
│   └── Repositories/       # Protocol definitions (NoteRepository, CategoryRepository)
├── Data/
│   ├── Models/             # Data models (SwiftData @Model classes: NoteModel, CategoryModel)
│   ├── Repositories/       # Protocol implementations (InMemory + SwiftData)
│   └── SeedData.swift      # Sample data for development
└── Core/
    ├── AppDependencies.swift   # Dependency injection container
    ├── Theme/
    │   ├── AppTypography.swift # Design system typography tokens
    │   └── AppColors.swift     # Design system color tokens
    └── Extensions/             # Swift extensions (Color+Hex, etc.)
```

## Architecture Rules

### 1. Presentation Layer

- **Views**: SwiftUI Views
- **ViewModels**: Manage presentation logic, fetch data via UseCases, expose data to Views
- Uses `@Observable` macro for ViewModels (iOS 17+)
- Prefer `@State`, `@Binding` for view-local state
- Use dependency injection via initializers

### 2. Domain Layer

- **UseCases**: Encapsulate business rules, coordinate Repository ↔ ViewModel data flow. Single public `execute()` method.
- **Entities**: Core business models — plain Swift structs, no framework dependencies
- **Repository Protocols**: Define data access contracts

### 3. Data Layer

- **Repositories**: Implement Domain protocols
- InMemory implementations + SwiftData implementations
- **Data Models**: `@Model` classes in `Data/Models/` for SwiftData persistence; map between Domain Entities and persistence

### 4. Design System (Core/Theme)

- `AppTypography`: Semantic typography tokens (displayLarge, headingSmall, bodyLarge, etc.) with mapping from system fonts
- `AppColors`: Semantic color tokens (textPrimary, textSecondary, textDestructive, etc.)
- Use `.appTypography(AppTypography.xxx)` for text with default color
- Use `.appTypography(AppTypography.xxx, colorOverride:)` for custom color
- Use `.font(.xxx)` when only font is needed (no color change)
- Use `AppColors` for semantic colors

### 5. Dependency Rule

Dependencies point inward: **Presentation → Domain ← Data**

---

## Architecture Mapping (iOS ↔ Other Platforms)

| iOS (Demo) | Android | Backend | Frontend |
|------------|---------|---------|----------|
| SwiftUI View | Jetpack Compose Screen | REST Controller / GraphQL Resolver | React/Vue/Angular Component |
| ViewModel (`@Observable`) | ViewModel (`StateFlow`) | Service Layer | Hooks / Store / Service |
| UseCase | UseCase | Service / UseCase | Custom Hook / Service |
| Entity (struct) | Entity (data class) | Entity / Model / DTO | Interface / Type / Model |
| Repository Protocol | Repository Interface | Repository Interface | API Service Interface |
| Repository Impl | Repository Impl | Repository Impl | API Service Impl |
| SwiftData Model | Room Entity | JPA Entity / ORM | N/A |
| InMemory Repository | Local DataSource | JPA Repository / ORM | LocalStorage / IndexedDB |
| AppTypography (ViewModifier) | AppTypography (TextStyle object) | N/A | Design tokens / CSS variables |
| AppColors (semantic) | AppColors (semantic) | N/A | Theme colors / CSS custom properties |
