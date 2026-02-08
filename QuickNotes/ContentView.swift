import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    // MARK: - Properties

    private let dependencies = AppDependencies()

    // MARK: - Body

    var body: some View {
        TabView {
            NoteListView(
                viewModel: dependencies.makeNoteListViewModel(),
                dependencies: dependencies
            )
            .tabItem {
                Label("Notes", systemImage: "note.text")
            }

            CategoryListView(viewModel: dependencies.makeCategoryListViewModel())
                .tabItem {
                    Label("Categories", systemImage: "folder")
                }

            SettingsView(viewModel: SettingsViewModel())
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }

            ProfileView(viewModel: ProfileViewModel())
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}
