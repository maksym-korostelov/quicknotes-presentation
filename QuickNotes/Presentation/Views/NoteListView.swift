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
                        .appTypography(AppTypography.bodyMedium)
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
                            .appTypography(AppTypography.headingLarge)
                    }
                }
            }
            .sheet(isPresented: $showingAddNote, onDismiss: {
                Task { await viewModel.loadNotes(sortOrder: SettingsViewModel.SortOrder(rawValue: sortOrderRaw) ?? .dateDescending) }
            }) {
                NoteEditorView(viewModel: dependencies.makeNoteEditorViewModel(), showCancelButton: true)
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
                .listRowBackground(noteRowGlassBackground)
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
                Text(emptyStateTitle)
                    .appTypography(AppTypography.bodyMedium, colorOverride: AppColors.textSecondary)
                Text(emptyStateSubtitle)
                    .appTypography(AppTypography.captionLarge, colorOverride: AppColors.textTertiary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }

    private var emptyStateTitle: String {
        if viewModel.showArchivedAndCompleted { return "No notes" }
        if viewModel.selectedCategoryId != nil { return "No notes in this category" }
        return "No notes yet"
    }

    private var emptyStateSubtitle: String {
        if viewModel.showArchivedAndCompleted { return "Archived and completed notes will appear here when you add them." }
        if viewModel.selectedCategoryId != nil { return "Choose \"All\" above to see all notes" }
        return "Tap the + button to create your first note"
    }

    // MARK: - Filter Section (Liquid Glass)

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

            Toggle("Show archived & completed", isOn: $viewModel.showArchivedAndCompleted)
        }
        .listRowBackground(
            Group {
                if #available(iOS 26.0, *) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.clear)
                        .glassEffect(in: .rect(cornerRadius: 16))
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                }
            }
        )
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

    /// Liquid glass background for note list rows (iOS 26+).
    @ViewBuilder
    private var noteRowGlassBackground: some View {
        if #available(iOS 26.0, *) {
            RoundedRectangle(cornerRadius: 12)
                .fill(.clear)
                .glassEffect(in: .rect(cornerRadius: 12))
        } else {
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        }
    }

    // MARK: - Note Row

    private func noteRow(_ note: Note) -> some View {
        HStack(alignment: .top, spacing: 10) {
            if note.isArchived || note.isCompleted {
                RoundedRectangle(cornerRadius: 2)
                    .fill(noteStatusAccentColor(note))
                    .frame(width: 4)
                    .frame(maxHeight: .infinity)
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .center, spacing: 6) {
                    if note.isPinned {
                        Image(systemName: "pin.fill")
                            .appTypography(AppTypography.captionSmall, colorOverride: AppColors.textSecondary)
                    }
                    Text(note.title)
                        .appTypography(AppTypography.headingSmall)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .strikethrough(note.isCompleted, color: AppColors.textSecondary)
                        .layoutPriority(0)
                    Spacer(minLength: 4)
                    noteStatusBadges(note)
                        .layoutPriority(1)
                }

                Text(note.content)
                    .appTypography(AppTypography.bodyMedium, colorOverride: AppColors.textSecondary)
                    .lineLimit(2)
                    .strikethrough(note.isCompleted, color: AppColors.textSecondary)

                HStack {
                    if let category = note.category {
                        Label(category.name, systemImage: category.icon)
                            .appTypography(AppTypography.captionLarge, colorOverride: Color(hex: category.colorHex))
                    }

                    Spacer()

                    Text(note.modifiedAt.formatted(date: .abbreviated, time: .shortened))
                        .appTypography(AppTypography.captionSmall, colorOverride: AppColors.textTertiary)
                }
            }
        }
        .padding(.vertical, 4)
        .opacity(note.isArchived ? 0.8 : 1)
    }

    @ViewBuilder
    private func noteStatusBadges(_ note: Note) -> some View {
        HStack(spacing: 6) {
            if note.isArchived {
                Label("Archived", systemImage: "archivebox.fill")
                    .appTypography(AppTypography.labelArchived)
                    .lineLimit(1)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(.quaternary)
                    .clipShape(Capsule())
            }
            if note.isCompleted {
                Label("Completed", systemImage: "checkmark.circle.fill")
                    .appTypography(AppTypography.labelCompleted)
                    .lineLimit(1)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(AppColors.labelCompleted.opacity(0.15))
                    .clipShape(Capsule())
            }
        }
        .fixedSize(horizontal: true, vertical: false)
    }

    private func noteStatusAccentColor(_ note: Note) -> Color {
        if note.isCompleted && note.isArchived { return AppColors.labelArchivedAndCompleted }
        if note.isCompleted { return AppColors.labelCompleted }
        if note.isArchived { return AppColors.labelArchived }
        return .clear
    }
}
