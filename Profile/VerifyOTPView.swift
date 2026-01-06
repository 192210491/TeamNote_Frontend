import SwiftUI

struct VerifyOTPView: View {

    let phoneNumber: String
    let onSuccess: () -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var otp = ""
    @State private var errorMessage: String?

    // 🔐 MOCK OTP (later replace with backend)
    private let mockOTP = "123456"

    var body: some View {
        VStack(spacing: 28) {

            // MARK: - Header
            VStack(spacing: 6) {
                Text("Verify OTP")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("OTP sent to +91 \(phoneNumber)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            // MARK: - OTP Field
            TextField("Enter 6-digit OTP", text: $otp)
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .font(.title2)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(16)

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            // MARK: - Verify Button
            Button {
                verifyOTP()
            } label: {
                Text("Verify & Enable")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        LinearGradient(
                            colors: [.green, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(18)
            }

            // MARK: - Resend
            Button("Resend OTP") {
                otp = ""
                errorMessage = nil
            }
            .font(.footnote)
            .foregroundColor(.blue)

            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .navigationTitle("OTP Verification")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Logic
    private func verifyOTP() {
        guard otp.count == 6 else {
            errorMessage = "Enter 6-digit OTP"
            return
        }

        if otp == mockOTP {
            onSuccess()
            dismiss()
        } else {
            errorMessage = "Invalid OTP"
        }
    }
}

