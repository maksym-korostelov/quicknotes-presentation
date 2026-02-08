import SwiftUI

// MARK: - NoteListView

struct NoteListView: View {

    // MARK: - Properties

    @State private var viewModel: NoteListViewModel
    @State private var showingEditor = false

    // MARK: - Initialization

    init(viewModel: NoteListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading notes...")
                        .font(.subheadline)
                } else if viewModel.notes.isEmpty {
                    emptyStateView
                } else {
                    noteListContent
                }
            }
            .navigationTitle("My Notes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingEditor = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingEditor) {
                AddNoteView { title, content in
                    viewModel.addNote(title: title, content: content)
                }
            }
            .task {
                await viewModel.loadNotes()
            }
        }
    }

    // MARK: - Subviews

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "note.text")
                .font(.system(size: 56))
                .foregroundStyle(.secondary)

            Text("No Notes Yet")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Tap the + button to create your first note.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }

    private var noteListContent: some View {
        List {
            ForEach(viewModel.notes) { note in
                noteRow(for: note)
            }
            .onDelete { indexSet in
                Task {
                    for index in indexSet {
                        let note = viewModel.notes[index]
                        await viewModel.deleteNote(id: note.id)
                    }
                }
            }

            // MARK: - Footer
            Section {
                Text("\(viewModel.notes.count) note(s)")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.insetGrouped)
    }

    private func noteRow(for note: Note) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(note.title)
                .font(.headline)
                .lineLimit(1)

            if !note.content.isEmpty {
                Text(note.content)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            HStack {
                if let category = note.category {
                    Label(category.name, systemImage: category.icon)
                        .font(.caption)
                        .foregroundStyle(.blue)
                }

                Spacer()

                Text(note.modifiedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}
