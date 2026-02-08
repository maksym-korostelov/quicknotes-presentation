import SwiftUI

// MARK: - CategoryListView

struct CategoryListView: View {
    // MARK: - Properties

    @State var viewModel: CategoryListViewModel

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
            .navigationTitle("Categories")
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
                categoryRow(category)
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
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(category.name)
                    .font(.headline)

                Text("\(category.noteCount) notes")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}
