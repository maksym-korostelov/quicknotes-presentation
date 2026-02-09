import SwiftUI

// MARK: - ContentView

struct ContentView: View {
    // MARK: - Properties

    private let dependencies = AppDependencies()
    @State private var selectedTabIndex = 0
    @State private var noteListFilterCategoryId: UUID?
    @State private var searchTabQuery = ""
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTabIndex) {
            Tab("Notes", systemImage: "note.text", value: 0) {
                NoteListView(
                    viewModel: dependencies.makeNoteListViewModel(),
                    dependencies: dependencies,
                    filterCategoryIdBinding: $noteListFilterCategoryId
                )
            }

            Tab("Categories", systemImage: "folder", value: 1) {
                CategoryListView(
                    viewModel: dependencies.makeCategoryListViewModel(),
                    onCategorySelected: { categoryId in
                        noteListFilterCategoryId = categoryId
                        selectedTabIndex = 0
                    }
                )
            }

            Tab("Settings", systemImage: "gear", value: 2) {
                SettingsView(viewModel: SettingsViewModel())
            }

            Tab("Profile", systemImage: "person.circle", value: 3) {
                ProfileView(viewModel: dependencies.makeProfileViewModel())
            }

            Tab(value: 4, role: .search) {
                NavigationStack {
                    SearchNotesView(dependencies: dependencies, searchQuery: $searchTabQuery)
                }
                .searchable(text: $searchTabQuery, prompt: "Search notes by title or content")
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { !hasCompletedOnboarding },
            set: { if $0 == false { hasCompletedOnboarding = true } }
        )) {
            OnboardingView(onComplete: {
                hasCompletedOnboarding = true
            })
        }
    }
}
