import SwiftUI

// MARK: - OnboardingView

struct OnboardingView: View {
    // MARK: - Properties

    var onComplete: () -> Void
    @State private var currentPage = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            icon: "note.text",
            title: "Welcome to QuickNotes",
            subtitle: "Capture your ideas and keep them organized in one place. Create notes, add categories, and find anything quickly with search."
        ),
        OnboardingPage(
            icon: "folder.fill",
            title: "Organize with categories",
            subtitle: "Group your notes by Work, Personal, Ideas, or any category you like. Tap a category to see only those notes."
        ),
        OnboardingPage(
            icon: "magnifyingglass",
            title: "Search in an instant",
            subtitle: "Use the Search tab to find notes by title or content. Your notes are always one tap away."
        )
    ]

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                skipButton
                    .padding(.trailing, 20)
                    .padding(.top, 12)
            }

            TabView(selection: $currentPage) {
                ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                    onboardingPageView(page)
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            pageIndicator
            actionButton
        }
        .padding(.bottom, 32)
    }

    // MARK: - Skip Button

    private var skipButton: some View {
        Button("Skip") {
            onComplete()
        }
        .appTypography(AppTypography.bodyLarge, colorOverride: AppColors.textSecondary)
    }

    // MARK: - Page Content

    private func onboardingPageView(_ page: OnboardingPage) -> some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: page.icon)
                .appTypography(AppTypography.iconHeroXLarge)

            Text(page.title)
                .appTypography(AppTypography.displayMedium)
                .multilineTextAlignment(.center)

            Text(page.subtitle)
                .appTypography(AppTypography.bodyLarge, colorOverride: AppColors.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()
        }
    }

    // MARK: - Page Indicator

    private var pageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<pages.count, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? AppColors.textAction : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 24)
    }

    // MARK: - Action Button

    private var actionButton: some View {
        Button {
            if currentPage < pages.count - 1 {
                withAnimation {
                    currentPage += 1
                }
            } else {
                onComplete()
            }
        } label: {
            Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                .appTypography(AppTypography.headingSmall)
                .frame(maxWidth: .infinity)
                .padding()
        }
        .buttonStyle(.borderedProminent)
        .padding(.horizontal, 24)
    }
}

// MARK: - OnboardingPage

private struct OnboardingPage {
    let icon: String
    let title: String
    let subtitle: String
}
