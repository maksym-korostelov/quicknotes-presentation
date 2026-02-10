import SwiftUI

// MARK: - CategoryListView

struct CategoryListView: View {
    // MARK: - Properties

    @State var viewModel: CategoryListViewModel
    private let dependencies: AppDependencies
    private let onCategorySelected: (UUID) -> Void

    @State private var showingAddCategory = false
    @State private var categoryToEdit: Category?
    @State private var categoryToDelete: Category?
    @State private var showDeleteConfirmation = false

    // MARK: - Initialization

    init(viewModel: CategoryListViewModel, dependencies: AppDependencies, onCategorySelected: @escaping (UUID) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.dependencies = dependencies
        self.onCategorySelected = onCategorySelected
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading && viewModel.categories.isEmpty {
                    ProgressView("Loading categories...")
                        .font(.subheadline)
                } else if viewModel.categories.isEmpty {
                    emptyStateView
                } else {
                    categoryListContent
                }
            }
            .refreshable {
                await viewModel.loadCategories()
            }
            .navigationTitle("Categories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddCategory = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .task {
                await viewModel.loadCategories()
            }
            .sheet(isPresented: $showingAddCategory, onDismiss: {
                Task { await viewModel.loadCategories() }
            }) {
                CategoryEditorView(
                    viewModel: dependencies.makeCategoryEditorViewModel(),
                    showCancelButton: true
                )
            }
            .sheet(item: $categoryToEdit, onDismiss: {
                Task { await viewModel.loadCategories() }
            }) { category in
                CategoryEditorView(
                    viewModel: dependencies.makeCategoryEditorViewModel(existingCategory: category),
                    showCancelButton: true
                )
            }
            .confirmationDialog("Delete Category", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
                Button("Delete", role: .destructive) {
                    if let category = categoryToDelete {
                        Task {
                            await viewModel.deleteCategory(id: category.id)
                        }
                    }
                    categoryToDelete = nil
                }
                Button("Cancel", role: .cancel) {
                    categoryToDelete = nil
                }
            } message: {
                if let category = categoryToDelete {
                    Text("“\(category.name)” will be removed from all notes. Notes in this category will become uncategorized.")
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

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "folder")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text("No Categories")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Tap + to create a category and organize your notes")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    // MARK: - Category List

    private var categoryListContent: some View {
        List {
            ForEach(viewModel.categories) { category in
                Button {
                    onCategorySelected(category.id)
                } label: {
                    categoryRow(category)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .contextMenu {
                    Button {
                        categoryToEdit = category
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                    Button(role: .destructive) {
                        categoryToDelete = category
                        showDeleteConfirmation = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .onDelete { indexSet in
                if let index = indexSet.first, index < viewModel.categories.count {
                    categoryToDelete = viewModel.categories[index]
                    showDeleteConfirmation = true
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    // MARK: - Category Row

    private func categoryRow(_ category: Category) -> some View {
        HStack(spacing: 12) {
            Image(systemName: category.icon)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 36, height: 36)
                .background(Color(hex: category.colorHex))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(category.name)
                    .font(.headline)

                Text("Tap to view notes")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
    }
}
