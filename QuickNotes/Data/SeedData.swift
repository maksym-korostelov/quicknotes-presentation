import Foundation

// MARK: - SeedData

/// Shared seed data for in-memory repositories so notes can reference the same category instances.
enum SeedData {

    /// Default categories used by both category and note repositories.
    static let defaultCategories: [Category] = [
        Category(name: "Work", icon: "briefcase.fill", colorHex: "F59E0B"),
        Category(name: "Personal", icon: "person.fill", colorHex: "3B82F6"),
        Category(name: "Ideas", icon: "lightbulb.fill", colorHex: "10B981")
    ]

    /// Default notes that reference the given categories. Pass `defaultCategories` so IDs match.
    static func defaultNotes(categories: [Category]) -> [Note] {
        let work = categories.first { $0.name == "Work" }
        let personal = categories.first { $0.name == "Personal" }
        let ideas = categories.first { $0.name == "Ideas" }

        return [
            Note(title: "Welcome to QuickNotes", content: "This is your first note. Tap + to create more!", category: nil),
            Note(title: "Shopping List", content: "Milk, Eggs, Bread, Butter", category: personal),
            Note(title: "Meeting Notes", content: "Discuss Q4 roadmap with the team.", category: work),
            Note(title: "Project Alpha ideas", content: "Consider dark mode, widgets, and offline sync.", category: ideas),
            Note(title: "Weekly standup", content: "• Backend API on track\n• Design review Thursday\n• Deploy to staging Friday", category: work),
            Note(title: "Books to read", content: "1. Deep Work\n2. Atomic Habits\n3. The Pragmatic Programmer", category: personal),
            Note(title: "Feature brainstorm", content: "Tags, reminders, rich text, export to PDF.", category: ideas),
            Note(title: "Vacation packing", content: "Passport, charger, adapters, meds, sunscreen.", category: personal),
            Note(title: "Sprint retrospective", content: "What went well: shipping on time. Improve: earlier QA involvement.", category: work),
            Note(title: "App name ideas", content: "NoteFlow, QuickJot, MemoBox, Scribble.", category: ideas)
        ]
    }
}
