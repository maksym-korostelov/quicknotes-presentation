import SwiftUI

// MARK: - CategoryListView

struct CategoryListView: View {

    // MARK: - Properties

    @State private var viewModel: CategoryListViewModel

    // MARK: - Initialization

    init(viewModel: CategoryListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading categories...")
                        .font(.subheadline)
                } else if viewModel.categories.isEmpty {
                    emptyStateView
                } else {
                    categoryListContent
                }
            }
            .navigationTitle("Categories")
            .task {
                await viewModel.loadCategories()
            }
        }
    }

    // MARK: - Subviews

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "folder")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text("No Categories")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Categories help you organize your notes. Create one to get started.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }

    private var categoryListContent: some View {
        List {
            ForEach(viewModel.categories) { category in
                categoryRow(for: category)
            }

            // MARK: - Summary Footer
            Section {
                Text("\(viewModel.categories.count) categories")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
            }
        }
        .listStyle(.insetGrouped)
    }

    private func categoryRow(for category: Category) -> some View {
        HStack(spacing: 12) {
            Image(systemName: category.icon)
                .font(.title3)
                .foregroundStyle(Color(hex: category.colorHex))
                .frame(width: 36, height: 36)
                .background(Color(hex: category.colorHex).opacity(0.15), in: RoundedRectangle(cornerRadius: 8))

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
        .padding(.vertical, 4)
    }
}

// MARK: - Color Extension (Hex Support)

private extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
