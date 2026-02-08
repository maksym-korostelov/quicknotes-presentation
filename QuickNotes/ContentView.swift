import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    // MARK: - Body

    var body: some View {
        TabView {
            NoteListView(viewModel: NoteListViewModel())
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }

            CategoryListView(viewModel: CategoryListViewModel())
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
