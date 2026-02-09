import SwiftUI

// MARK: - NoteListView

struct NoteListView: View {
    // MARK: - Properties

    @State private var viewModel: NoteListViewModel
    @State private var showingAddNote = false
    @AppStorage("sortOrder") private var sortOrderRaw = SettingsViewModel.SortOrder.dateDescending.rawValue
    private let dependencies: AppDependencies
    /// When provided (e.g. from ContentView), filter is synced with this binding so Categories tab can switch here with a preset filter.
    private var filterCategoryIdBinding: Binding<UUID?>?

    // MARK: - Initialization

    init(viewModel: NoteListViewModel, dependencies: AppDependencies, filterCategoryIdBinding: Binding<UUID?>? = nil) {
        _viewModel = State(initialValue: viewModel)
        self.dependencies = dependencies
        self.filterCategoryIdBinding = filterCategoryIdBinding
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading notes...")
                        .font(.subheadline)
                } else {
                    noteListContent
                }
            }
            .refreshable {
                await viewModel.loadNotes(sortOrder: SettingsViewModel.SortOrder(rawValue: sortOrderRaw) ?? .dateDescending)
            }
            .navigationTitle(navigationTitle)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddNote = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddNote, onDismiss: {
                Task { await viewModel.loadNotes(sortOrder: SettingsViewModel.SortOrder(rawValue: sortOrderRaw) ?? .dateDescending) }
            }) {
                NoteEditorView(viewModel: dependencies.makeNoteEditorViewModel())
            }
            .task {
                await viewModel.loadNotes(sortOrder: SettingsViewModel.SortOrder(rawValue: sortOrderRaw) ?? .dateDescending)
            }
            .onChange(of: sortOrderRaw) { _, _ in
                Task {
                    await viewModel.loadNotes(sortOrder: SettingsViewModel.SortOrder(rawValue: sortOrderRaw) ?? .dateDescending)
                }
            }
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.clearError() } }
            )) {
                Button("OK") { viewModel.clearError() }
            } message: {
                if let message = viewModel.errorMessage {
                    Text(message)
                }
            }
            .task {
                await viewModel.loadCategories()
            }
            .onAppear {
                if let binding = filterCategoryIdBinding {
                    viewModel.selectedCategoryId = binding.wrappedValue
                }
            }
            .onChange(of: filterCategoryIdBinding?.wrappedValue) { _, newValue in
                viewModel.selectedCategoryId = newValue
            }
        }
    }

    private var navigationTitle: String {
        "My Notes"
    }

    // MARK: - Note List

    private var noteListContent: some View {
        List {
            filterSection
            if viewModel.filteredNotes.isEmpty {
                emptyStateInListSection
            }
            ForEach(viewModel.filteredNotes) { note in
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
                        let note = viewModel.filteredNotes[index]
                        await viewModel.deleteNote(id: note.id)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    /// Shown inside the list when there are no notes to show (so filter stays visible on main tab).
    private var emptyStateInListSection: some View {
        Section {
            VStack(spacing: 8) {
                Text(viewModel.selectedCategoryId != nil ? "No notes in this category" : "No notes yet")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(viewModel.selectedCategoryId != nil ? "Choose \"All\" above to see all notes" : "Tap the + button to create your first note")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }

    // MARK: - Filter Section

    private var filterSection: some View {
        Section {
            Picker("Category", selection: filterPickerSelection) {
                Text("All").tag(nil as UUID?)
                ForEach(viewModel.categories) { category in
                    Label(category.name, systemImage: category.icon)
                        .tag(category.id as UUID?)
                }
            }
            .labelsHidden()
        }
    }

    private var filterPickerSelection: Binding<UUID?> {
        if let binding = filterCategoryIdBinding {
            return binding
        }
        return Binding(
            get: { viewModel.selectedCategoryId },
            set: { viewModel.selectedCategoryId = $0 }
        )
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
