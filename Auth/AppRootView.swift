import SwiftUI

struct AppRootView: View {

    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @State private var showSplash = true

    var body: some View {
        ZStack {

            if showSplash {
                SplashView()
            }
            else if !hasSeenOnboarding {
                OnboardingView()
            }
            else if !isLoggedIn {
                AuthEntryView()
            }
            else {
                MainTabView()
            }

        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showSplash = false
            }
        }
    }
}
