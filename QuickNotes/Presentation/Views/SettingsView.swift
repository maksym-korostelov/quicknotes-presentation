import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {
    // MARK: - Properties

    @State var viewModel: SettingsViewModel

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Form {
                appearanceSection
                notificationsSection
                sortOrderSection
                dataSection
                aboutSection
            }
            .navigationTitle("Settings")
        }
    }

    // MARK: - Appearance Section

    private var appearanceSection: some View {
        Section {
            Toggle("Dark Mode", isOn: $viewModel.isDarkModeEnabled)
                .appTypography(AppTypography.bodyLarge)
        } header: {
            Text("Appearance")
                .appTypography(AppTypography.captionLarge)
        } footer: {
            Text("Customize how QuickNotes looks")
                .appTypography(AppTypography.captionSmall, colorOverride: AppColors.textSecondary)
        }
    }

    // MARK: - Notifications Section

    private var notificationsSection: some View {
        Section {
            Toggle("Enable Notifications", isOn: $viewModel.isNotificationsEnabled)
                .appTypography(AppTypography.bodyLarge)
        } header: {
            Text("Notifications")
                .appTypography(AppTypography.captionLarge)
        } footer: {
            Text("Manage how QuickNotes sends you notifications")
                .appTypography(AppTypography.bodySmallHint)
        }
    }

    // MARK: - Sort Order Section

    @AppStorage("sortOrder") private var sortOrderRaw = SettingsViewModel.SortOrder.dateDescending.rawValue

    private var sortOrderSection: some View {
        Section {
            Picker("Sort notes by", selection: $sortOrderRaw) {
                ForEach(SettingsViewModel.SortOrder.allCases, id: \.self) { order in
                    Text(order.rawValue).tag(order.rawValue)
                }
            }
            .appTypography(AppTypography.bodyLarge)
        } header: {
            Text("Sort Order")
                .appTypography(AppTypography.captionLarge)
        } footer: {
            Text("Applies to the order of notes in the Notes tab")
                .appTypography(AppTypography.captionSmall, colorOverride: AppColors.textSecondary)
        }
    }

    // MARK: - Data Section

    private var dataSection: some View {
        Section {
            Button(action: {}) {
                HStack {
                    Text("Export Notes")
                        .appTypography(AppTypography.bodyLargeAction)
                    Spacer()
                    Image(systemName: "square.and.arrow.up")
                        .appTypography(AppTypography.bodyLarge)
                }
            }

            Button(action: {}) {
                HStack {
                    Text("Import Notes")
                        .appTypography(AppTypography.bodyLargeAction)
                    Spacer()
                    Image(systemName: "square.and.arrow.down")
                        .appTypography(AppTypography.bodyLarge)
                }
            }

            Button(role: .destructive, action: {}) {
                HStack {
                    Text("Delete All Notes")
                        .appTypography(AppTypography.bodyLargeDestructive)
                    Spacer()
                    Image(systemName: "trash")
                        .appTypography(AppTypography.bodyLarge)
                }
            }
        } header: {
            Text("Data")
                .appTypography(AppTypography.captionLarge)
        }
    }

    // MARK: - About Section

    private var aboutSection: some View {
        Section {
            NavigationLink {
                AboutView()
            } label: {
                Text("About QuickNotes")
                    .appTypography(AppTypography.bodyLarge)
            }

            NavigationLink {
                HelpView()
            } label: {
                Text("Help")
                    .appTypography(AppTypography.bodyLarge)
            }

            HStack {
                Text("Version")
                    .appTypography(AppTypography.bodyLarge)
                Spacer()
                Text("1.0.0")
                    .appTypography(AppTypography.bodyMediumValue)
            }

            HStack {
                Text("Build")
                    .appTypography(AppTypography.bodyLarge)
                Spacer()
                Text("2025.1")
                    .appTypography(AppTypography.bodyMediumValue)
            }

            Link(destination: URL(string: "https://example.com/privacy")!) {
                Text("Privacy Policy")
                    .appTypography(AppTypography.bodyLargeAction)
            }

            Link(destination: URL(string: "https://example.com/terms")!) {
                Text("Terms of Service")
                    .appTypography(AppTypography.bodyLargeAction)
            }
        } header: {
            Text("About")
                .appTypography(AppTypography.captionLarge)
        } footer: {
            Text("Made with ❤️ using SwiftUI")
                .appTypography(AppTypography.bodySmall)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
        }
    }
}
