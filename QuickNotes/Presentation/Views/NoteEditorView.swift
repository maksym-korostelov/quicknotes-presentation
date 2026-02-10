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
                    .font(.body)
                    .fontWeight(.semibold)
                    .disabled(!viewModel.isValid || viewModel.isLoading)
                }
            }
            .task {
                await viewModel.loadCategories()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Saving...")
                        .font(.subheadline)
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
                .font(.system(size: 18, weight: .medium))
        } header: {
            Text("Title")
                .font(.headline)
        }
    }

    // MARK: - Content Section

    private var contentSection: some View {
        Section {
            TextEditor(text: $viewModel.content)
                .font(.body)
                .frame(minHeight: 200)
        } header: {
            Text("Content")
                .font(.headline)
        } footer: {
            Text("\(viewModel.content.count) characters")
                .font(.caption2)
                .foregroundStyle(.secondary)
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
                            .foregroundStyle(.primary)
                    } else {
                        Text("None")
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .font(.body)
            }
        } header: {
            Text("Category")
                .font(.headline)
        } footer: {
            Text("Organize your note by assigning a category")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Pin Section

    private var pinSection: some View {
        Section {
            Toggle("Pin to top", isOn: $viewModel.isPinned)
                .font(.body)
        } header: {
            Text("Pin")
                .font(.headline)
        } footer: {
            Text("Pinned notes appear at the top of the list")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
