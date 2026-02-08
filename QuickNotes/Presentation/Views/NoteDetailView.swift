import SwiftUI

// MARK: - NoteDetailView

struct NoteDetailView: View {

    // MARK: - Properties

    @State private var viewModel: NoteDetailViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Initialization

    init(viewModel: NoteDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
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
        .navigationTitle("Note Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button(role: .destructive) {
                    Task {
                        await viewModel.deleteNote()
                        dismiss()
                    }
                } label: {
                    Image(systemName: "trash")
                }
                .disabled(viewModel.isLoading)
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
    }

    // MARK: - Subviews

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.note.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .lineLimit(3)

            if let category = viewModel.note.category {
                Label(category.name, systemImage: category.icon)
                    .font(.subheadline)
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.blue.opacity(0.1), in: Capsule())
            }
        }
    }

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Content")
                .font(.title3)
                .fontWeight(.semibold)

            if viewModel.note.content.isEmpty {
                Text("No content available.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                Text(viewModel.note.content)
                    .font(.body)
                    .lineSpacing(4)
            }
        }
    }

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Details")
                .font(.title3)
                .fontWeight(.semibold)

            metadataRow(label: "Created", value: viewModel.note.createdAt.formatted(date: .long, time: .shortened))
            metadataRow(label: "Last Modified", value: viewModel.note.updatedAt.formatted(date: .long, time: .shortened))
            metadataRow(label: "Word Count", value: "\(viewModel.note.content.split(separator: " ").count) words")
        }
    }

    private func metadataRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .frame(width: 120, alignment: .leading)

            Text(value)
                .font(.footnote)
        }
    }
}
