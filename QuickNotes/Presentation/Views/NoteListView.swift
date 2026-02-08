import SwiftUI

// MARK: - NoteListView

struct NoteListView: View {
    // MARK: - Properties

    @State private var viewModel: NoteListViewModel
    @State private var showingAddNote = false
    private let dependencies: AppDependencies

    // MARK: - Initialization

    init(viewModel: NoteListViewModel, dependencies: AppDependencies) {
        _viewModel = State(initialValue: viewModel)
        self.dependencies = dependencies
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddNote = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddNote, onDismiss: {
                Task { await viewModel.loadNotes() }
            }) {
                NoteEditorView(viewModel: dependencies.makeNoteEditorViewModel())
            }
            .task {
                await viewModel.loadNotes()
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
                NavigationLink(
                    destination: NoteDetailView(
                        viewModel: dependencies.makeNoteDetailViewModel(note: note),
                        dependencies: dependencies
                    )
                ) {
                    noteRow(note)
                }
            }
            .onDelete { indexSet in
                Task {
                    for index in indexSet {
                        let note = viewModel.notes[index]
                        await viewModel.deleteNote(id: note.id)
                    }
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

                Text(note.modifiedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 4)
    }
}
