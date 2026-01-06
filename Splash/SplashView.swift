import SwiftUI

struct SplashView: View {

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.black, .purple.opacity(0.9)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Spacer()

                RoundedRectangle(cornerRadius: 22)
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 90, height: 90)
                    .overlay(
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                    )

                Text("TeamNote")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundColor(.white)

                Text("Manage Tasks, Events & Team Progress")
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Spacer()
            }
        }
    }
}

