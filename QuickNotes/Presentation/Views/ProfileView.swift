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
        }
    }

    // MARK: - Avatar Section

    private var avatarSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)

            Text(viewModel.profile.name)
                .font(.title)
                .fontWeight(.bold)

            Text(viewModel.profile.email)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("Member since \(viewModel.profile.memberSince.formatted(date: .long, time: .omitted))")
                .font(.caption)
                .foregroundStyle(.tertiary)
        }
    }

    // MARK: - Stats Section

    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Activity")
                .font(.title2)
                .fontWeight(.semibold)

            HStack(spacing: 16) {
                statCard(title: "Notes", value: "\(viewModel.profile.totalNotes)", icon: "note.text")
                statCard(title: "Categories", value: "\(viewModel.profile.totalCategories)", icon: "folder")
            }
        }
    }

    // MARK: - Stat Card

    private func statCard(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(.blue)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
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
                .font(.title2)
                .fontWeight(.semibold)

            Button(action: {}) {
                HStack {
                    Label("Edit Profile", systemImage: "pencil")
                        .font(.body)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)

            Button(action: {}) {
                HStack {
                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                        .font(.body)
                        .foregroundStyle(.red)
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
