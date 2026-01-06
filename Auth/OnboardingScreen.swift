import SwiftUI

struct OnboardingScreen: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        VStack(spacing: 28) {
            Spacer()

            // Icon card
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [Color.blue, Color.purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 42))
                        .foregroundColor(.white)
                )

            // Title
            Text(title)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            // Subtitle
            Text(subtitle)
                .font(.system(size: 15))
                .foregroundColor(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 36)

            Spacer()
        }
        .padding()
    }
}


