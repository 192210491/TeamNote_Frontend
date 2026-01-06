import SwiftUI

struct Enable2FAView: View {

    @Environment(\.dismiss) private var dismiss

    @AppStorage("is2FAEnabled") private var is2FAEnabled: Bool = false
    @AppStorage("userPhoneNumber") private var savedPhone: String = ""

    @State private var phoneNumber = ""
    @State private var showOTP = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 24) {

            // MARK: - Header
            VStack(spacing: 6) {
                Text("Two-Factor Authentication")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Secure your account with OTP verification")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // MARK: - Phone Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Mobile Number")
                    .font(.footnote)
                    .foregroundColor(.secondary)

                HStack {
                    Text("+91")
                        .foregroundColor(.secondary)

                    TextField("Enter phone number", text: $phoneNumber)
                        .keyboardType(.numberPad)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(16)
            }

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            // MARK: - Send OTP
            Button {
                sendOTP()
            } label: {
                Text("Send OTP")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(18)
            }
            .padding(.top, 10)

            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .navigationTitle("2FA Setup")
        .navigationBarTitleDisplayMode(.inline)

        // MARK: - OTP Sheet
        .sheet(isPresented: $showOTP) {
            VerifyOTPView(
                phoneNumber: phoneNumber,
                onSuccess: {
                    savedPhone = "+91 \(phoneNumber)"
                    is2FAEnabled = true
                    dismiss()
                }
            )
        }
    }

    // MARK: - Logic
    private func sendOTP() {
        let trimmed = phoneNumber.trimmingCharacters(in: .whitespaces)

        guard trimmed.count == 10 else {
            errorMessage = "Enter a valid 10-digit number"
            return
        }

        errorMessage = nil
        showOTP = true
    }
}

