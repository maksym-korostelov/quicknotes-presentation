import SwiftUI

// MARK: - AddNoteView

/// Simple editor for adding a new note.
struct AddNoteView: View {

    // MARK: - Properties

    @State private var title = ""
    @State private var content = ""
    @Environment(\.dismiss) private var dismiss

    private let onSave: (String, String) -> Void

    // MARK: - Initialization

    /// Creates a new add note view.
    /// - Parameter onSave: Callback invoked with the note title and content.
    init(onSave: @escaping (String, String) -> Void) {
        self.onSave = onSave
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Form {
                titleSection
                contentSection
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave(title.trimmingCharacters(in: .whitespacesAndNewlines), content)
                        dismiss()
                    }
                    .disabled(isSaveDisabled)
                }
            }
        }
    }

    // MARK: - Subviews

    private var titleSection: some View {
        Section {
            TextField("Note title", text: $title)
                .appTypography(AppTypography.headingSmall)
        } header: {
            Text("Title")
                .appTypography(AppTypography.captionLarge)
                .textCase(.uppercase)
        } footer: {
            if isSaveDisabled {
                Text("Title is required")
                    .appTypography(AppTypography.captionSmall, colorOverride: AppColors.textDestructive)
            }
        }
    }

    private var contentSection: some View {
        Section {
            TextEditor(text: $content)
                .appTypography(AppTypography.bodyLarge)
                .frame(minHeight: 200)
        } header: {
            Text("Content")
                .appTypography(AppTypography.captionLarge)
                .textCase(.uppercase)
        } footer: {
            Text("\(content.count) characters")
                .appTypography(AppTypography.captionSmall, colorOverride: AppColors.textSecondary)
        }
    }

    // MARK: - Private Methods

    private var isSaveDisabled: Bool {
        title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
