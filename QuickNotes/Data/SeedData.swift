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
            Note(title: "Welcome to QuickNotes", content: "Your first note. Tap + to add more. Or don’t—we’re not your manager.", category: nil, isPinned: true),
            Note(title: "Shopping List", content: "Milk, eggs, bread, and that thing I forgot the moment I left the store.", category: personal),
            Note(title: "Meeting Notes", content: "Could have been an email. It was 47 minutes. I took one actionable bullet.", category: work),
            Note(title: "Project Alpha ideas", content: "Dark mode (so I look serious), widgets (so I look busy), sync (so I don’t lose this).", category: ideas),
            Note(title: "Weekly standup", content: "• Blocked on something I could Google\n• Will unblock myself after this meeting\n• No further questions", category: work),
            Note(title: "Books to read", content: "1. That one everyone recommended\n2. The one I bought and didn’t open\n3. The one I’ll definitely start next month", category: personal),
            Note(title: "Feature brainstorm", content: "Tags (so I can ignore them), reminders (so I can snooze them), export (so I can never find the file).", category: ideas),
            Note(title: "Vacation packing", content: "Passport, charger, adapters. The rest is optimism and hope.", category: personal),
            Note(title: "Sprint retrospective", content: "What went well: we survived. Improve: everything. Action items: see last retro.", category: work),
            Note(title: "App name ideas", content: "NoteFlow (taken), QuickJot (taken), MemoBox (sounds like a cereal). Back to the drawing board.", category: ideas)
        ]
    }
}
