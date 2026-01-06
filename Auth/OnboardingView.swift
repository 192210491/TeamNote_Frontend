import SwiftUI

struct OnboardingView: View {

    @State private var page = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color.black,
                    Color.purple.opacity(0.9)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                TabView(selection: $page) {

                    OnboardingScreen(
                        title: "Create Focused Groups",
                        subtitle: "Manage 4–5 members effortlessly.",
                        icon: "person.3.fill"
                    )
                    .tag(0)

                    OnboardingScreen(
                        title: "Capture Any Type of Work",
                        subtitle: "Text, image, and voice updates turned into tasks.",
                        icon: "square.and.pencil"
                    )
                    .tag(1)

                    OnboardingScreen(
                        title: "Track Smarter with AI",
                        subtitle: "Accountability, insights, and timeline replay.",
                        icon: "chart.bar.fill"
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))

                Button {
                    if page < 2 {
                        page += 1
                    } else {
                        // ✅ THIS IS ALL YOU NEED
                        hasSeenOnboarding = true
                    }
                } label: {
                    Text(page == 2 ? "Get Started" : "Next")
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding(.horizontal, 24)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

