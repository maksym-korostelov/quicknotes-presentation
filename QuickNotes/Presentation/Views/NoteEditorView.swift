import SwiftUI

// MARK: - NoteEditorView

struct NoteEditorView: View {

    // MARK: - Properties

    @State private var viewModel: NoteEditorViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Initialization

    init(viewModel: NoteEditorViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Form {
                titleSection
                contentSection
                categorySection
            }
            .navigationTitle("Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
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
                    .font(.headline)
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
        }
    }

    // MARK: - Subviews

    private var titleSection: some View {
        Section {
            TextField("Note title", text: $viewModel.title)
                .font(.system(size: 18, weight: .medium))
        } header: {
            Text("Title")
                .font(.caption)
                .textCase(.uppercase)
        } footer: {
            if viewModel.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text("Title is required")
                    .font(.caption2)
                    .foregroundStyle(.red)
            }
        }
    }

    private var contentSection: some View {
        Section {
            TextEditor(text: $viewModel.content)
                .font(.body)
                .frame(minHeight: 200)
        } header: {
            Text("Content")
                .font(.caption)
                .textCase(.uppercase)
        } footer: {
            Text("\(viewModel.content.count) characters")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private var categorySection: some View {
        Section {
            if viewModel.categories.isEmpty {
                Text("No categories available")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            } else {
                Picker("Category", selection: $viewModel.selectedCategory) {
                    Text("None")
                        .font(.subheadline)
                        .tag(nil as Category?)

                    ForEach(viewModel.categories) { category in
                        Label(category.name, systemImage: category.icon)
                            .font(.subheadline)
                            .tag(category as Category?)
                    }
                }
            }
        } header: {
            Text("Category")
                .font(.caption)
                .textCase(.uppercase)
        }
    }
}
