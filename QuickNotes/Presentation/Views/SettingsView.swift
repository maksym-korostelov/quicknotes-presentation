import SwiftUI

// MARK: - SettingsView

struct SettingsView: View {

    // MARK: - Properties

    @State private var viewModel = SettingsViewModel()

    // MARK: - Body

    var body: some View {
        NavigationStack {
            Form {
                appearanceSection
                notesSection
                notificationsSection
                aboutSection
            }
            .navigationTitle("Settings")
        }
    }

    // MARK: - Subviews

    private var appearanceSection: some View {
        Section {
            Toggle(isOn: $viewModel.isDarkModeEnabled) {
                Label("Dark Mode", systemImage: "moon.fill")
                    .font(.body)
            }
        } header: {
            Text("Appearance")
                .font(.caption)
                .textCase(.uppercase)
        } footer: {
            Text("Override system appearance settings.")
                .font(.caption2)
        }
    }

    private var notesSection: some View {
        Section {
            Picker("Sort Order", selection: $viewModel.sortOrder) {
                ForEach(SettingsViewModel.SortOrder.allCases) { order in
                    Text(order.rawValue)
                        .font(.body)
                        .tag(order)
                }
            }

            HStack {
                Text("Auto-save Interval")
                    .font(.body)
                Spacer()
                Text("\(viewModel.autoSaveInterval)s")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text("Default Category")
                    .font(.body)
                Spacer()
                Text(viewModel.defaultCategoryName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        } header: {
            Text("Notes")
                .font(.caption)
                .textCase(.uppercase)
        }
    }

    private var notificationsSection: some View {
        Section {
            Toggle(isOn: $viewModel.isNotificationsEnabled) {
                Label("Reminders", systemImage: "bell.fill")
                    .font(.body)
            }
        } header: {
            Text("Notifications")
                .font(.caption)
                .textCase(.uppercase)
        } footer: {
            Text("Receive reminders for scheduled notes.")
                .font(.caption2)
        }
    }

    private var aboutSection: some View {
        Section {
            HStack {
                Text("Version")
                    .font(.body)
                Spacer()
                Text(viewModel.appVersion)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text("Build")
                    .font(.body)
                Spacer()
                Text(viewModel.buildNumber)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Link(destination: URL(string: "https://quicknotes.app/privacy")!) {
                HStack {
                    Text("Privacy Policy")
                        .font(.body)
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Link(destination: URL(string: "https://quicknotes.app/terms")!) {
                HStack {
                    Text("Terms of Service")
                        .font(.body)
                    Spacer()
                    Image(systemName: "arrow.up.right.square")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        } header: {
            Text("About")
                .font(.caption)
                .textCase(.uppercase)
        }
    }
}
