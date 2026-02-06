import SwiftUI

// MARK: - NoteListView

/// Main view displaying the list of notes.
struct NoteListView: View {
    
    // MARK: - Properties
    
    @State private var viewModel: NoteListViewModel
    @State private var showingAddNote = false
    
    // MARK: - Initialization
    
    init(viewModel: NoteListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.notes) { note in
                    NoteRowView(note: note)
                }
                .onDelete(perform: deleteNotes)
            }
            .navigationTitle("QuickNotes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddNote = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddNote) {
                AddNoteView { title, content in
                    viewModel.addNote(title: title, content: content)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func deleteNotes(at offsets: IndexSet) {
        for index in offsets {
            viewModel.deleteNote(viewModel.notes[index])
        }
    }
}

// MARK: - NoteRowView

/// Row view for displaying a single note in the list.
struct NoteRowView: View {
    
    let note: Note
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(note.title)
                .font(.headline)
            
            Text(note.content)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            
            Text(note.createdAt.formatted(date: .abbreviated, time: .shortened))
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - AddNoteView

/// Sheet view for creating a new note.
struct AddNoteView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var content = ""
    
    let onSave: (String, String) -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                
                Section("Content") {
                    TextEditor(text: $content)
                        .frame(minHeight: 200)
                }
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(title, content)
                        dismiss()
                    }
                    .disabled(title.isEmpty)
                }
            }
        }
    }
}

// MARK: - Preview

#Preview {
    NoteListView(viewModel: NoteListViewModel())
}
