import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    // MARK: - Properties

    private let dependencies = AppDependencies()
    @State private var selectedTabIndex = 0
    @State private var noteListFilterCategoryId: UUID?

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTabIndex) {
            NoteListView(
                viewModel: dependencies.makeNoteListViewModel(),
                dependencies: dependencies,
                filterCategoryIdBinding: $noteListFilterCategoryId
            )
            .tabItem {
                Label("Notes", systemImage: "note.text")
            }
            .tag(0)

            CategoryListView(
                viewModel: dependencies.makeCategoryListViewModel(),
                onCategorySelected: { categoryId in
                    noteListFilterCategoryId = categoryId
                    selectedTabIndex = 0
                }
            )
            .tabItem {
                Label("Categories", systemImage: "folder")
            }
            .tag(1)

            SettingsView(viewModel: SettingsViewModel())
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
            .tag(2)

            ProfileView(viewModel: ProfileViewModel())
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
            .tag(3)
        }
    }
}
