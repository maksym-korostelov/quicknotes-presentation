import SwiftUI

// MARK: - ProfileView

struct ProfileView: View {

    // MARK: - Properties

    @State private var viewModel = ProfileViewModel()

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ScrollView {
                if let profile = viewModel.profile {
                    VStack(spacing: 24) {
                        avatarSection(profile: profile)
                        Divider()
                        statsSection(profile: profile)
                        Divider()
                        detailsSection(profile: profile)
                        Spacer(minLength: 40)
                        signOutButton
                    }
                    .padding()
                } else {
                    ProgressView("Loading profile...")
                        .font(.subheadline)
                }
            }
            .navigationTitle("Profile")
        }
    }

    // MARK: - Subviews

    private func avatarSection(profile: UserProfile) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)

            Text(profile.displayName)
                .font(.title)
                .fontWeight(.bold)

            Text(profile.email)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func statsSection(profile: UserProfile) -> some View {
        HStack(spacing: 40) {
            statItem(value: "\(profile.notesCount)", label: "Notes")
            statItem(value: "\(profile.categoriesCount)", label: "Categories")
            statItem(value: memberSince(profile.joinedDate), label: "Member Since")
        }
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)

            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func detailsSection(profile: UserProfile) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Account Details")
                .font(.headline)
                .padding(.bottom, 4)

            detailRow(icon: "person.fill", title: "Display Name", value: profile.displayName)
            detailRow(icon: "envelope.fill", title: "Email", value: profile.email)
            detailRow(icon: "calendar", title: "Joined", value: profile.joinedDate.formatted(date: .long, time: .omitted))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func detailRow(icon: String, title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .foregroundStyle(.blue)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(value)
                    .font(.body)
            }
        }
    }

    private var signOutButton: some View {
        Button(role: .destructive) {
            // Sign out action
        } label: {
            Text("Sign Out")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
        }
        .buttonStyle(.bordered)
        .tint(.red)
    }

    // MARK: - Helpers

    private func memberSince(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"
        return formatter.string(from: date)
    }
}
