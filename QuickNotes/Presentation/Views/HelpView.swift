import SwiftUI

// MARK: - HelpView

struct HelpView: View {
    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                introSection
                creatingNotesSection
                organizingSection
                searchSection
                tipsSection
            }
            .padding()
        }
        .navigationTitle("Help")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Intro

    private var introSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How to use QuickNotes")
                .font(.title2)
                .fontWeight(.bold)

            Text("QuickNotes helps you capture and organize your notes with categories and search. Here’s a quick guide to get the most out of the app.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Creating Notes

    private var creatingNotesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Creating notes", systemImage: "square.and.pencil")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Tap the + button on the Notes tab to create a new note. Add a title and content, and optionally assign a category. Tap Save to keep your note.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Organizing

    private var organizingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Organizing with categories", systemImage: "folder")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Use the Categories tab to see all your categories. Tap a category to jump to the Notes tab with that filter applied. You can filter notes by category using the picker at the top of the Notes list.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Search

    private var searchSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Searching notes", systemImage: "magnifyingglass")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Tap the Search tab and type in the search field at the bottom. Notes are searched by title and content. Clear the search to see all notes again.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Tips

    private var tipsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tips")
                .font(.title3)
                .fontWeight(.semibold)

            VStack(alignment: .leading, spacing: 8) {
                tipRow(number: 1, text: "Swipe left on a note in the list to delete it.")
                tipRow(number: 2, text: "Use the Sort Order setting to sort notes by date or title.")
                tipRow(number: 3, text: "Tap a note to view it in full; tap Edit to make changes.")
            }
            .font(.body)
            .foregroundStyle(.secondary)
        }
    }

    private func tipRow(number: Int, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number).")
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
            Text(text)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
}
