import SwiftUI

// MARK: - ProfileView

struct ProfileView: View {
    // MARK: - Properties

    @State var viewModel: ProfileViewModel

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    avatarSection
                    statsSection
                    actionsSection
                }
                .padding()
            }
            .navigationTitle("Profile")
            .task {
                await viewModel.loadProfile()
            }
            .refreshable {
                await viewModel.loadProfile()
            }
        }
    }

    // MARK: - Avatar Section

    private var avatarSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .appTypography(AppTypography.iconHeroXXLarge)

            Text(viewModel.profile?.displayName ?? "User")
                .appTypography(AppTypography.displayMedium)

            Text(viewModel.profile?.email ?? "")
                .appTypography(AppTypography.bodyMedium, colorOverride: AppColors.textSecondary)

            if let joinedDate = viewModel.profile?.joinedDate {
                Text("Member since \(joinedDate.formatted(date: .long, time: .omitted))")
                    .appTypography(AppTypography.captionLarge, colorOverride: AppColors.textTertiary)
            }
        }
    }

    // MARK: - Stats Section

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Activity")
                .appTypography(AppTypography.headingLarge)

            HStack(spacing: 16) {
                if let profile = viewModel.profile {
                    statCard(title: "Notes", value: "\(profile.notesCount)", icon: "note.text")
                    statCard(title: "Categories", value: "\(profile.categoriesCount)", icon: "folder")
                }
            }
        }
    }

    // MARK: - Stat Card

    private func statCard(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .appTypography(AppTypography.headingSmall, colorOverride: AppColors.textAction)

            Text(value)
                .appTypography(AppTypography.headingLarge)

            Text(title)
                .appTypography(AppTypography.captionLarge, colorOverride: AppColors.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: - Actions Section

    private var actionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Account")
                .appTypography(AppTypography.headingLarge)

            Button(action: {}) {
                HStack {
                    Label("Edit Profile", systemImage: "pencil")
                        .appTypography(AppTypography.bodyLarge)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .appTypography(AppTypography.captionLarge, colorOverride: AppColors.textTertiary)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)

            Button(action: {}) {
                HStack {
                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                        .appTypography(AppTypography.bodyLarge, colorOverride: AppColors.textDestructive)
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
    }
}
