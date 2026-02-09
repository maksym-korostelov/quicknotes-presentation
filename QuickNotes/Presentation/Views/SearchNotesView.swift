import SwiftUI

// MARK: - SearchNotesView

/// Search-focused notes view for the Search tab. Used with Tab(role: .search) so the search field appears in the tab bar at the bottom (default iOS behavior).
struct SearchNotesView: View {
    // MARK: - Properties

    private let dependencies: AppDependencies
    @Binding var searchQuery: String
    @State private var notes: [Note] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    private var filteredNotes: [Note] {
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return notes }
        return notes.filter {
            $0.title.localizedCaseInsensitiveContains(query) ||
            $0.content.localizedCaseInsensitiveContains(query)
        }
    }

    // MARK: - Initialization

    init(dependencies: AppDependencies, searchQuery: Binding<String>) {
        self.dependencies = dependencies
        _searchQuery = searchQuery
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                if isLoading {
                    ProgressView("Loading...")
                        .font(.subheadline)
                } else if filteredNotes.isEmpty {
                    emptyStateView
                } else {
                    searchResultsList
                }
            }
            .navigationTitle("Search")
            .refreshable {
                await loadNotes()
            }
            .task {
                await loadNotes()
            }
            .alert("Error", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK") { errorMessage = nil }
            } message: {
                if let message = errorMessage {
                    Text(message)
                }
            }
        }
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        ContentUnavailableView {
            Label("No Notes", systemImage: "magnifyingglass")
        } description: {
            Text(
                searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    ? "Enter a search term to find notes."
                    : "No notes match \"\(searchQuery)\"."
            )
        }
    }

    // MARK: - Results List

    private var searchResultsList: some View {
        List {
            ForEach(filteredNotes) { note in
                NavigationLink(
                    destination: NoteDetailView(
                        viewModel: dependencies.makeNoteDetailViewModel(note: note),
                        dependencies: dependencies
                    )
                ) {
                    noteRow(note)
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

    // MARK: - Actions

    @MainActor
    private func loadNotes() async {
        isLoading = true
        errorMessage = nil
        do {
            notes = try await dependencies.getNotesUseCase.execute()
            notes.sort { $0.modifiedAt > $1.modifiedAt }
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
