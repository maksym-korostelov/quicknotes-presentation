import Foundation
import Observation

// MARK: - NoteListViewModel

/// ViewModel for the notes list screen.
@Observable
final class NoteListViewModel {
    
    // MARK: - Properties
    
    /// List of notes to display
    private(set) var notes: [Note] = []
    
    /// Loading state indicator
    private(set) var isLoading = false
    
    /// Error message if something goes wrong
    private(set) var errorMessage: String?
    
    // MARK: - Initialization
    
    init() {
        // Load sample data for demo
        loadSampleData()
    }
    
    // MARK: - Public Methods
    
    /// Adds a new note to the list
    func addNote(title: String, content: String) {
        let note = Note(title: title, content: content)
        notes.insert(note, at: 0)
    }
    
    /// Deletes a note from the list
    func deleteNote(_ note: Note) {
        notes.removeAll { $0.id == note.id }
    }
    
    // MARK: - Private Methods
    
    private func loadSampleData() {
        notes = [
            Note(title: "Welcome to QuickNotes", content: "This is your first note. Tap + to create more!"),
            Note(title: "Shopping List", content: "Milk, Eggs, Bread, Butter"),
            Note(title: "Meeting Notes", content: "Discuss Q4 roadmap with the team")
        ]
    }
}
