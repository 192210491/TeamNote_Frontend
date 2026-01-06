import SwiftUI

struct ChangePasswordView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""

    @State private var showCurrent = false
    @State private var showNew = false
    @State private var showConfirm = false

    private var isValid: Bool {
        !currentPassword.isEmpty &&
        newPassword.count >= 6 &&
        newPassword == confirmPassword
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {

                // MARK: - Header
                VStack(spacing: 6) {
                    Text("Change Password")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Update your account password")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 12)

                // MARK: - Form
                VStack(spacing: 18) {

                    passwordField(
                        title: "Current Password",
                        text: $currentPassword,
                        isVisible: $showCurrent
                    )

                    passwordField(
                        title: "New Password",
                        text: $newPassword,
                        isVisible: $showNew
                    )

                    passwordField(
                        title: "Re-enter New Password",
                        text: $confirmPassword,
                        isVisible: $showConfirm
                    )

                    if !confirmPassword.isEmpty && newPassword != confirmPassword {
                        Text("Passwords do not match")
                            .font(.caption)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                // MARK: - Update Button
                Button {
                    // 🔐 Backend later
                    dismiss()
                } label: {
                    Text("Update Password")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            LinearGradient(
                                colors: isValid
                                ? [.blue, .purple]
                                : [.gray.opacity(0.4), .gray.opacity(0.4)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(18)
                }
                .disabled(!isValid)

                Spacer()
            }
            .padding(24)
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Password Field
    private func passwordField(
        title: String,
        text: Binding<String>,
        isVisible: Binding<Bool>
    ) -> some View {

        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            HStack {
                if isVisible.wrappedValue {
                    TextField(title, text: text)
                } else {
                    SecureField(title, text: text)
                }

                Button {
                    isVisible.wrappedValue.toggle()
                } label: {
                    Image(systemName: isVisible.wrappedValue ? "eye.slash" : "eye")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(14)
        }
    }
}

