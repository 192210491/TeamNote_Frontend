import SwiftUI

struct LogoutView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 28) {

            Spacer()

            // Icon
            Image(systemName: "arrow.backward.square.fill")
                .font(.system(size: 64))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.red, .pink, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            // Title
            Text("Logout")
                .font(.title)
                .fontWeight(.bold)

            // Message
            Text("Are you sure you want to logout from your account?")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Spacer()

            // Logout Button
            Button {
                // 🔴 TODO: clear auth state here
                print("User logged out")
            } label: {
                Text("Logout")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [.red, .pink, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(18)
            }

            // Cancel Button
            Button {
                dismiss()
            } label: {
                Text("Cancel")
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Logout")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    if #available(iOS 16.0, *) {
        NavigationStack {
            LogoutView()
        }
    } else {
        // Fallback on earlier versions
    }
}

