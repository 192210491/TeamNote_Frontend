import SwiftUI

struct OTPView: View {

    let email: String
    @Binding var path: [AuthRoute]

    @State private var otp: [String] = Array(repeating: "", count: 6)
    @FocusState private var focusedIndex: Int?

    @State private var errorMessage = ""
    @State private var isLoading = false

    // ⚠️ Change IP when testing on real device
    private let BASE_URL = "http://localhost/teamnote_api"

    var body: some View {
        ZStack {

            // 🌙 Auth Background
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

                    // Back
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
                        Text("Verify OTP")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("Enter the 6-digit code sent to \(email)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    // OTP Boxes
                    HStack(spacing: 14) {
                        ForEach(0..<6, id: \.self) { index in
                            TextField("", text: $otp[index])
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .font(.system(size: 22, weight: .semibold))
                                .frame(width: 48, height: 56)
                                .background(Color(.tertiarySystemFill))
                                .cornerRadius(14)
                                .focused($focusedIndex, equals: index)
                                .onChange(of: otp[index]) { newValue in
                                    handleChange(index: index, value: newValue)
                                }
                        }
                    }
                    .padding(.top, 6)
                    .onAppear { focusedIndex = 0 }

                    // ❌ Error
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    // Verify Button
                    Button {
                        verifyOTP()
                    } label: {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(
                                    CircularProgressViewStyle(tint: .white)
                                )
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                        } else {
                            Text("Verify OTP")
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
                    .padding(.top, 10)
                    .disabled(isLoading)

                    Button("Resend OTP") {
                        resendOTP()
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
                .padding(28)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.35), radius: 20, y: 10)
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }

    // MARK: - OTP Input Logic
    private func handleChange(index: Int, value: String) {
        if value.count > 1 {
            otp[index] = String(value.last!)
        }

        if !value.isEmpty {
            focusedIndex = index < 5 ? index + 1 : nil
        }

        if value.isEmpty, index > 0 {
            focusedIndex = index - 1
        }
    }

    // MARK: - VERIFY OTP (BACKEND)
    private func verifyOTP() {
        let code = otp.joined()

        guard code.count == 6 else {
            errorMessage = "Enter 6-digit OTP"
            return
        }

        guard let url = URL(string: "\(BASE_URL)/auth/verify_otp.php") else { return }

        isLoading = true
        errorMessage = ""

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "email": email,
            "otp": code
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
                    path.append(.reset(email: email))
                } else {
                    errorMessage = json["message"] as? String ?? "Invalid or expired OTP"
                }
            }
        }.resume()
    }

    private func resendOTP() {
        // Optional: call forgot_password.php again
        print("Resend OTP for:", email)
    }
}

