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
                dataSection
                aboutSection
            }
            .navigationTitle("Settings")
        }
    }

    // MARK: - Appearance Section

    private var appearanceSection: some View {
        Section {
            Picker("Theme", selection: $viewModel.selectedTheme) {
                Text("System").tag(0)
                Text("Light").tag(1)
                Text("Dark").tag(2)
            }
            .font(.body)

            Picker("Font Size", selection: $viewModel.fontSize) {
                Text("Small").tag(0)
                Text("Medium").tag(1)
                Text("Large").tag(2)
            }
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
            Toggle("Enable Reminders", isOn: $viewModel.remindersEnabled)
                .font(.body)

            Toggle("Daily Summary", isOn: $viewModel.dailySummaryEnabled)
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
