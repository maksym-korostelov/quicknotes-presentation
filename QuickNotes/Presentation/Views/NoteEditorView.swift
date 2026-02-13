import SwiftUI

// MARK: - NoteEditorView

struct NoteEditorView: View {
    // MARK: - Properties

    @State var viewModel: NoteEditorViewModel
    @Environment(\.dismiss) private var dismiss

    /// When true, shows a Cancel button (e.g. when presented as a sheet). When false, only the system back button is used (e.g. when pushed via NavigationLink).
    private var showCancelButton: Bool

    init(viewModel: NoteEditorViewModel, showCancelButton: Bool = false) {
        _viewModel = State(initialValue: viewModel)
        self.showCancelButton = showCancelButton
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Form {
                titleSection
                contentSection
                categorySection
                pinSection
            }
            .navigationTitle("Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if showCancelButton {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            dismiss()
                        }
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            await viewModel.save()
                            if viewModel.isSaved {
                                dismiss()
                            }
                        }
                    }
                    .appTypography(AppTypography.bodyLarge)
                    .disabled(!viewModel.isValid || viewModel.isLoading)
                }
            }
            .task {
                await viewModel.loadCategories()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Saving...")
                        .appTypography(AppTypography.bodyMedium)
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
        }
    }

    // MARK: - Title Section

    private var titleSection: some View {
        Section {
            TextField("Note title", text: $viewModel.title)
                .appTypography(AppTypography.headingSmall)
        } header: {
            Text("Title")
                .appTypography(AppTypography.headingSmall)
        }
    }

    // MARK: - Content Section

    private var contentSection: some View {
        Section {
            TextEditor(text: $viewModel.content)
                .appTypography(AppTypography.bodyLarge)
                .frame(minHeight: 200)
        } header: {
            Text("Content")
                .appTypography(AppTypography.headingSmall)
        } footer: {
            Text("\(viewModel.content.count) characters")
                .appTypography(AppTypography.captionSmall, colorOverride: AppColors.textSecondary)
        }
    }

    // MARK: - Category Section

    private var categorySection: some View {
        Section {
            Menu {
                Button {
                    viewModel.selectedCategory = nil
                } label: {
                    Label("None", systemImage: "xmark.circle")
                }

                ForEach(viewModel.categories) { category in
                    Button {
                        viewModel.selectedCategory = category
                    } label: {
                        Label {
                            Text(category.name)
                        } icon: {
                            Image(systemName: category.icon)
                                .foregroundStyle(Color(hex: category.colorHex))
                        }
                    }
                }
            } label: {
                HStack {
                    if let category = viewModel.selectedCategory {
                        Image(systemName: category.icon)
                            .foregroundStyle(Color(hex: category.colorHex))
                        Text(category.name)
                            .foregroundStyle(AppColors.textPrimary)
                    } else {
                        Text("None")
                            .foregroundStyle(AppColors.textSecondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .appTypography(AppTypography.captionLarge, colorOverride: AppColors.textTertiary)
                }
                .appTypography(AppTypography.bodyLarge)
            }
        } header: {
            Text("Category")
                .appTypography(AppTypography.headingSmall)
        } footer: {
            Text("Organize your note by assigning a category")
                .appTypography(AppTypography.captionLarge, colorOverride: AppColors.textSecondary)
        }
    }

    // MARK: - Pin Section

    private var pinSection: some View {
        Section {
            Toggle("Pin to top", isOn: $viewModel.isPinned)
                .appTypography(AppTypography.bodyLarge)
        } header: {
            Text("Pin")
                .appTypography(AppTypography.headingSmall)
        } footer: {
            Text("Pinned notes appear at the top of the list")
                .appTypography(AppTypography.captionLarge, colorOverride: AppColors.textSecondary)
        }
    }
}
