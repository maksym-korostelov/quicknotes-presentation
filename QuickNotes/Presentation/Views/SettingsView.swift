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
                .font(.body)
        } header: {
            Text("Appearance")
                .font(.caption)
        } footer: {
            Text("Customize how QuickNotes looks")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Notifications Section

    private var notificationsSection: some View {
        Section {
            Toggle("Enable Notifications", isOn: $viewModel.isNotificationsEnabled)
                .font(.body)
        } header: {
            Text("Notifications")
                .font(.caption)
        } footer: {
            Text("Manage how QuickNotes sends you notifications")
                .font(.caption2)
                .foregroundStyle(.secondary)
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
            .font(.body)
        } header: {
            Text("Sort Order")
                .font(.caption)
        } footer: {
            Text("Applies to the order of notes in the Notes tab")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: - Data Section

    private var dataSection: some View {
        Section {
            Button(action: {}) {
                HStack {
                    Text("Export Notes")
                        .font(.body)
                    Spacer()
                    Image(systemName: "square.and.arrow.up")
                        .font(.body)
                }
            }

            Button(action: {}) {
                HStack {
                    Text("Import Notes")
                        .font(.body)
                    Spacer()
                    Image(systemName: "square.and.arrow.down")
                        .font(.body)
                }
            }

            Button(role: .destructive, action: {}) {
                HStack {
                    Text("Delete All Notes")
                        .font(.body)
                    Spacer()
                    Image(systemName: "trash")
                        .font(.body)
                }
            }
        } header: {
            Text("Data")
                .font(.caption)
        }
    }

    // MARK: - About Section

    private var aboutSection: some View {
        Section {
            HStack {
                Text("Version")
                    .font(.body)
                Spacer()
                Text("1.0.0")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text("Build")
                    .font(.body)
                Spacer()
                Text("2025.1")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Link(destination: URL(string: "https://example.com/privacy")!) {
                Text("Privacy Policy")
                    .font(.body)
            }

            Link(destination: URL(string: "https://example.com/terms")!) {
                Text("Terms of Service")
                    .font(.body)
            }
        } header: {
            Text("About")
                .font(.caption)
        } footer: {
            Text("Made with ❤️ using SwiftUI")
                .font(.footnote)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
        }
    }
}
