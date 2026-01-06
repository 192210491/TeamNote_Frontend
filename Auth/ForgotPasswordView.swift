import SwiftUI

struct ForgotPasswordView: View {

    @Binding var path: [AuthRoute]

    @State private var email = ""
    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {
        ZStack {

            // 🌙 Auth Background (consistent)
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

                // MARK: - Card
                VStack(spacing: 22) {

                    // Back to Login
                    HStack {
                        Button {
                            path = [.login]
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.left")
                                Text("Back to Login")
                            }
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        }
                        Spacer()
                    }

                    // Title
                    VStack(spacing: 6) {
                        Text("Forgot Password?")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("Enter your email to receive an OTP")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    // Email Field
                    inputField(
                        icon: "envelope.fill",
                        placeholder: "Email",
                        text: $email
                    )

                    // ❌ Error Message
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    // MARK: - Send OTP Button
                    Button {
                        sendOTP()
                    } label: {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(
                                    CircularProgressViewStyle(tint: .white)
                                )
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                        } else {
                            Text("Send OTP")
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
                    .shadow(
                        color: Color.black.opacity(0.3),
                        radius: 10,
                        y: 6
                    )
                    .padding(.top, 8)
                    .disabled(isLoading)
                }
                .padding(28)
                .background(
                    Color(.secondarySystemGroupedBackground)
                )
                .cornerRadius(30)
                .shadow(
                    color: Color.black.opacity(0.35),
                    radius: 20,
                    y: 10
                )
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }

    // MARK: - API CALL
    private func sendOTP() {
        errorMessage = ""
        isLoading = true

        ForgotPasswordService.shared.sendOTP(email: email) { result in
            DispatchQueue.main.async {
                isLoading = false

                switch result {
                case .success(let success):
                    if success {
                        // ✅ FIX: no email passed in route
                        path.append(.otp(email: email))

                    } else {
                        errorMessage = "Email not found"
                    }

                case .failure:
                    errorMessage = "Server error. Try again."
                }
            }
        }
    }

    // MARK: - Reusable Auth Input
    func inputField(
        icon: String,
        placeholder: String,
        text: Binding<String>
    ) -> some View {

        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 22)

            TextField(placeholder, text: text)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
        }
        .padding()
        .background(Color(.tertiarySystemFill))
        .cornerRadius(16)
    }
}

