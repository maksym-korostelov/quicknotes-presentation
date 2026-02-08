import SwiftUI

// MARK: - ContentView

struct ContentView: View {

    // MARK: - Properties

    @State private var selectedTab: Tab = .notes

    // MARK: - Tab Definition

    enum Tab: String, CaseIterable {
        case notes = "Notes"
        case categories = "Categories"
        case settings = "Settings"
        case profile = "Profile"

        var icon: String {
            switch self {
            case .notes: return "note.text"
            case .categories: return "folder"
            case .settings: return "gearshape"
            case .profile: return "person.circle"
            }
        }
    }

    // MARK: - Body

    var body: some View {
        TabView(selection: $selectedTab) {
            // Note: Using placeholder ViewModels for now.
            // Proper dependency injection will be added in a later session.

            Text("Notes Tab Placeholder")
                .font(.title2)
                .tabItem {
                    Label(Tab.notes.rawValue, systemImage: Tab.notes.icon)
                }
                .tag(Tab.notes)

            Text("Categories Tab Placeholder")
                .font(.title2)
                .tabItem {
                    Label(Tab.categories.rawValue, systemImage: Tab.categories.icon)
                }
                .tag(Tab.categories)

            SettingsView()
                .tabItem {
                    Label(Tab.settings.rawValue, systemImage: Tab.settings.icon)
                }
                .tag(Tab.settings)

            ProfileView()
                .tabItem {
                    Label(Tab.profile.rawValue, systemImage: Tab.profile.icon)
                }
                .tag(Tab.profile)
        }
    }
}
