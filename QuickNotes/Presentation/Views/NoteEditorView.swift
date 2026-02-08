import SwiftUI

// MARK: - NoteEditorView

struct NoteEditorView: View {
    // MARK: - Properties

    @State var viewModel: NoteEditorViewModel
    @Environment(\.dismiss) private var dismiss

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
            Picker("Category", selection: $viewModel.selectedCategory) {
                Text("None")
                    .font(.body)
                    .tag(nil as Category?)

                ForEach(viewModel.categories) { category in
                    Label(category.name, systemImage: category.icon)
                        .font(.body)
                        .tag(category as Category?)
                }
            }
            .font(.subheadline)
        } header: {
            Text("Category")
                .font(.headline)
        } footer: {
            Text("Organize your note by assigning a category")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}
