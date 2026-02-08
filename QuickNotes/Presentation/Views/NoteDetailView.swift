import SwiftUI

// MARK: - NoteDetailView

struct NoteDetailView: View {
    // MARK: - Properties

    @State var viewModel: NoteDetailViewModel

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
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: NoteEditorView(viewModel: NoteEditorViewModel(note: viewModel.note))) {
                    Text("Edit")
                        .font(.body)
                        .fontWeight(.medium)
                }
            }
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.note.title)
                .font(.largeTitle)
                .fontWeight(.bold)

            if let category = viewModel.note.category {
                Label(category.name, systemImage: category.icon)
                    .font(.subheadline)
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(.blue.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
    }

    // MARK: - Content Section

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Content")
                .font(.title3)
                .fontWeight(.semibold)

            Text(viewModel.note.content)
                .font(.body)
                .lineSpacing(4)
        }
    }

    // MARK: - Metadata Section

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Details")
                .font(.title3)
                .fontWeight(.semibold)

            HStack {
                Label("Created", systemImage: "calendar")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(viewModel.note.createdAt.formatted(date: .long, time: .shortened))
                    .font(.footnote)
            }

            HStack {
                Label("Modified", systemImage: "clock")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(viewModel.note.updatedAt.formatted(date: .long, time: .shortened))
                    .font(.footnote)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
