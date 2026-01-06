import SwiftUI

struct ResetPasswordView: View {

    let email: String
    @Binding var path: [AuthRoute]

    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage = ""
    @State private var isLoading = false

    // ⚠️ Change IP when testing on real device
    private let BASE_URL = "http://localhost/teamnote_api"

    var body: some View {
        ZStack {

            // 🌙 Background
            LinearGradient(
                colors: [
                    Color.black,
                    Color.purple.opacity(0.85),
                    Color.pink.opacity(0.75)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 22) {

                    // Title
                    VStack(spacing: 6) {
                        Text("Reset Password")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("Reset password for")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        Text(email)
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }

                    // New Password
                    SecureField("New Password", text: $password)
                        .padding()
                        .background(Color(.tertiarySystemFill))
                        .cornerRadius(16)

                    // Confirm Password
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(Color(.tertiarySystemFill))
                        .cornerRadius(16)

                    // ❌ Error
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    // Reset Button
                    Button {
                        resetPassword()
                    } label: {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(
                                    CircularProgressViewStyle(tint: .white)
                                )
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                        } else {
                            Text("Reset Password")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                        }
                    }
                    .background(
                        LinearGradient(
                            colors: [.blue, .purple, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.3), radius: 10, y: 6)
                    .disabled(isLoading)
                }
                .padding(28)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(30)
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }

    // MARK: - RESET PASSWORD API (BACKEND)
    private func resetPassword() {

        guard !password.isEmpty else {
            errorMessage = "Password cannot be empty"
            return
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters"
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

        guard let url = URL(string: "\(BASE_URL)/auth/reset_password.php") else { return }

        isLoading = true
        errorMessage = ""

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "email": email,
            "password": password
        ])

        URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.main.async { isLoading = false }

            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let success = json["success"] as? Bool
            else {
                DispatchQueue.main.async {
                    errorMessage = "Server error"
                }
                return
            }

            DispatchQueue.main.async {
                if success {
                    // ✅ Reset done → go to Login
                    path = [.login]
                } else {
                    errorMessage = json["message"] as? String ?? "Reset failed"
                }
            }
        }.resume()
    }
}

