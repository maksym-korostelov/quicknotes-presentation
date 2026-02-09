import SwiftUI

// MARK: - AboutView

struct AboutView: View {
    // MARK: - Body

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                appHeaderSection
                versionSection
                creditsSection
                linksSection
                footerSection
            }
            .padding()
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - App Header

    private var appHeaderSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "note.text")
                .font(.system(size: 64))
                .foregroundStyle(.blue)

            Text("QuickNotes")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Capture ideas. Stay organized.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 24)
    }

    // MARK: - Version

    private var versionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Version")
                .font(.headline)

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
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Credits

    private var creditsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Credits")
                .font(.title3)
                .fontWeight(.semibold)

            Text("QuickNotes is built with SwiftUI and follows iOS design guidelines. Icons and visuals are designed to keep your notes simple and accessible.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Links

    private var linksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Legal")
                .font(.title3)
                .fontWeight(.semibold)

            Link(destination: URL(string: "https://example.com/privacy")!) {
                HStack {
                    Text("Privacy Policy")
                        .font(.body)
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Link(destination: URL(string: "https://example.com/terms")!) {
                HStack {
                    Text("Terms of Service")
                        .font(.body)
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Footer

    private var footerSection: some View {
        Text("Made with ❤️ using SwiftUI")
            .font(.footnote)
            .foregroundStyle(.tertiary)
            .padding(.top, 16)
    }
}
