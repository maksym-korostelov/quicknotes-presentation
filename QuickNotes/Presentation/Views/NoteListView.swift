import SwiftUI

// MARK: - NoteListView

struct NoteListView: View {
    // MARK: - Properties

    @State var viewModel: NoteListViewModel
    @State private var showingAddNote = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.notes.isEmpty {
                    emptyStateView
                } else {
                    noteListContent
                }
            }
            .navigationTitle("My Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddNote = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddNote) {
                AddNoteView(viewModel: NoteEditorViewModel())
            }
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "note.text")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)

            Text("No Notes Yet")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Tap the + button to create your first note")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    // MARK: - Note List

    private var noteListContent: some View {
        List {
            ForEach(viewModel.notes) { note in
                NavigationLink(destination: NoteDetailView(viewModel: NoteDetailViewModel(note: note))) {
                    noteRow(note)
                }
            }
            .onDelete { indexSet in
                for index in indexSet {
                    let note = viewModel.notes[index]
                    viewModel.deleteNote(note)
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    // MARK: - Note Row

    private func noteRow(_ note: Note) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(note.title)
                .font(.headline)
                .lineLimit(1)

            Text(note.content)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            HStack {
                if let category = note.category {
                    Label(category.name, systemImage: category.icon)
                        .font(.caption)
                        .foregroundStyle(.blue)
                }

                Spacer()

                Text(note.updatedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}
