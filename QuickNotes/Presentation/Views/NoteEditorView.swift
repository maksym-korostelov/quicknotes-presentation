import SwiftUI

// MARK: - NoteEditorView

struct NoteEditorView: View {
    // MARK: - Properties

    @State var viewModel: NoteEditorViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showAddTagSheet = false
    @State private var newTagName = ""
    @State private var newTagColorHex = "3B82F6"

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
                tagsSection
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
                await viewModel.loadTags()
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
            .sheet(isPresented: $showAddTagSheet) {
                addTagSheet
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

    // MARK: - Tags Section

    private var tagsSection: some View {
        Section {
            if !viewModel.availableTags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.availableTags) { tag in
                            TagChip(
                                tag: tag,
                                isSelected: viewModel.selectedTags.contains(tag)
                            ) {
                                viewModel.toggleTag(tag)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            Button {
                newTagName = ""
                newTagColorHex = "3B82F6"
                showAddTagSheet = true
            } label: {
                Label("New Tag", systemImage: "plus.circle")
                    .appTypography(AppTypography.bodyLarge, colorOverride: AppColors.textAction)
            }
        } header: {
            Text("Tags")
                .appTypography(AppTypography.headingSmall)
        } footer: {
            if !viewModel.selectedTags.isEmpty {
                Text("Selected: \(viewModel.selectedTags.map(\.name).joined(separator: ", "))")
                    .appTypography(AppTypography.captionLarge, colorOverride: AppColors.textSecondary)
            }
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

    // MARK: - Add Tag Sheet

    private var addTagSheet: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Tag name", text: $newTagName)
                        .appTypography(AppTypography.bodyLarge)
                } header: {
                    Text("Name")
                        .appTypography(AppTypography.headingSmall)
                }

                Section {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 8), spacing: 12) {
                        ForEach(tagColorOptions, id: \.self) { hex in
                            Circle()
                                .fill(Color(hex: hex))
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary, lineWidth: newTagColorHex == hex ? 2.5 : 0)
                                )
                                .onTapGesture {
                                    newTagColorHex = hex
                                }
                        }
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Color")
                        .appTypography(AppTypography.headingSmall)
                }
            }
            .navigationTitle("New Tag")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showAddTagSheet = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        Task {
                            await viewModel.createAndSelectTag(name: newTagName, colorHex: newTagColorHex)
                            showAddTagSheet = false
                        }
                    }
                    .disabled(newTagName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

// MARK: - TagChip

private struct TagChip: View {
    let tag: Tag
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(tag.name)
                .appTypography(AppTypography.captionLarge)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color(hex: tag.colorHex).opacity(isSelected ? 0.25 : 0.1))
                .foregroundStyle(Color(hex: tag.colorHex))
                .clipShape(Capsule())
                .overlay(Capsule().stroke(Color(hex: tag.colorHex), lineWidth: isSelected ? 1.5 : 0.5))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Tag Color Options

private let tagColorOptions: [String] = [
    "EF4444", "F97316", "EAB308", "22C55E",
    "14B8A6", "3B82F6", "A855F7", "EC4899"
]
