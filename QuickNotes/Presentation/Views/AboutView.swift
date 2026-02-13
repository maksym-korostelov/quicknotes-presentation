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
                .appTypography(AppTypography.iconHeroLarge)

            Text("QuickNotes")
                .appTypography(AppTypography.displayLarge)
                .fontWeight(.bold)

            Text("Capture ideas. Stay organized.")
                .appTypography(AppTypography.bodyMedium, colorOverride: AppColors.textSecondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 24)
    }

    // MARK: - Version

    private var versionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Version")
                .appTypography(AppTypography.headingSmall)

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
                .appTypography(AppTypography.headingMedium)

            Text("QuickNotes is built with SwiftUI and follows iOS design guidelines. Icons and visuals are designed to keep your notes simple and accessible.")
                .appTypography(AppTypography.bodyLarge, colorOverride: AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Links

    private var linksSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Legal")
                .appTypography(AppTypography.headingMedium)

            Link(destination: URL(string: "https://example.com/privacy")!) {
                HStack {
                    Text("Privacy Policy")
                        .appTypography(AppTypography.bodyLargeAction)
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .appTypography(AppTypography.captionLarge, colorOverride: AppColors.textSecondary)
                }
            }

            Link(destination: URL(string: "https://example.com/terms")!) {
                HStack {
                    Text("Terms of Service")
                        .appTypography(AppTypography.bodyLargeAction)
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .appTypography(AppTypography.captionLarge, colorOverride: AppColors.textSecondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Footer

    private var footerSection: some View {
        Text("Made with ❤️ using SwiftUI")
            .appTypography(AppTypography.bodySmall, colorOverride: AppColors.textTertiary)
            .padding(.top, 16)
    }
}
