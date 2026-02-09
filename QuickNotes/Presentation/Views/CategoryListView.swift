import SwiftUI

// MARK: - CategoryListView

struct CategoryListView: View {
    // MARK: - Properties

    @State var viewModel: CategoryListViewModel
    private let onCategorySelected: (UUID) -> Void

    // MARK: - Initialization

    init(viewModel: CategoryListViewModel, onCategorySelected: @escaping (UUID) -> Void) {
        _viewModel = State(initialValue: viewModel)
        self.onCategorySelected = onCategorySelected
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.categories.isEmpty {
                    emptyStateView
                } else {
                    categoryListContent
                }
            }
            .refreshable {
                await viewModel.loadCategories()
            }
            .navigationTitle("Categories")
            .task {
                await viewModel.loadCategories()
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

            Text("Categories help you organize your notes")
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
