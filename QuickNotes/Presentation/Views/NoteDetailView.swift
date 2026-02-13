import SwiftUI

// MARK: - NoteDetailView

struct NoteDetailView: View {
    // MARK: - Properties

    @State private var viewModel: NoteDetailViewModel
    @State private var showDeleteConfirmation = false
    @Environment(\.dismiss) private var dismiss
    private let dependencies: AppDependencies

    // MARK: - Initialization

    init(viewModel: NoteDetailViewModel, dependencies: AppDependencies) {
        _viewModel = State(initialValue: viewModel)
        self.dependencies = dependencies
    }

    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                Divider()
                contentSection
                Divider()
                metadataSection
            }
            .padding()
        }
        .navigationTitle("Note")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack(spacing: 16) {
                    Button {
                        Task { await viewModel.togglePin() }
                    } label: {
                        Image(systemName: viewModel.note.isPinned ? "pin.fill" : "pin.slash")
                    }
                    Button {
                        Task { await viewModel.toggleArchive() }
                    } label: {
                        Image(systemName: viewModel.note.isArchived ? "archivebox.fill" : "archivebox")
                    }
                    .help(viewModel.note.isArchived ? "Unarchive" : "Archive")
                    Button {
                        Task { await viewModel.toggleCompleted() }
                    } label: {
                        Image(systemName: viewModel.note.isCompleted ? "checkmark.circle.fill" : "checkmark.circle")
                    }
                    .help(viewModel.note.isCompleted ? "Mark incomplete" : "Mark completed")
                    Button(role: .destructive) {
                        showDeleteConfirmation = true
                    } label: {
                        Image(systemName: "trash")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(
                    destination: NoteEditorView(
                        viewModel: dependencies.makeNoteEditorViewModel(note: viewModel.note),
                        showCancelButton: false
                    )
                ) {
                    Text("Edit")
                        .appTypography(AppTypography.bodyLarge)
                }
            }
        }
        .confirmationDialog("Delete Note", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteNote()
                    if viewModel.errorMessage == nil {
                        dismiss()
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This note will be permanently deleted.")
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
        .onAppear {
            Task { await viewModel.refreshNote() }
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.note.title)
                .appTypography(AppTypography.displayLarge)

            if let category = viewModel.note.category {
                Label(category.name, systemImage: category.icon)
                    .appTypography(AppTypography.bodyMedium, colorOverride: Color(hex: category.colorHex))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: category.colorHex).opacity(0.15))
                    .clipShape(Capsule())
            }
        }
    }

    // MARK: - Content Section

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Content")
                .appTypography(AppTypography.headingMedium)

            Text(viewModel.note.content)
                .appTypography(AppTypography.bodyLarge)
                .lineSpacing(4)
        }
    }

    // MARK: - Metadata Section

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Details")
                .appTypography(AppTypography.headingMedium)

            HStack {
                Label("Created", systemImage: "calendar")
                    .appTypography(AppTypography.bodySmall, colorOverride: AppColors.textSecondary)
                Spacer()
                Text(viewModel.note.createdAt.formatted(date: .long, time: .shortened))
                    .appTypography(AppTypography.bodySmall)
            }

            HStack {
                Label("Modified", systemImage: "clock")
                    .appTypography(AppTypography.bodySmall, colorOverride: AppColors.textSecondary)
                Spacer()
                Text(viewModel.note.modifiedAt.formatted(date: .long, time: .shortened))
                    .appTypography(AppTypography.bodySmall)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
