import SwiftUI

struct JoinGroupView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var groupStore: GroupStore   // ✅ REQUIRED

    @AppStorage("currentUserName")
    private var currentUserName: String = "Guest"

    @State private var inviteCode = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {

            Text("Join a Group")
                .font(.title2)
                .bold()

            TextField("Enter invite code", text: $inviteCode)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.characters)

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button("Join Group") {
                joinGroup()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(14)

            Spacer()
        }
        .padding()
    }

    // MARK: - Join Logic (INVITE FLOW)
    private func joinGroup() {
        let trimmed = inviteCode.trimmingCharacters(in: .whitespaces)

        guard !trimmed.isEmpty else {
            errorMessage = "Enter invite code"
            return
        }

        errorMessage = nil

        groupStore.joinGroup(inviteCode: trimmed) { success, message in
            if success {
                dismiss()
            } else {
                errorMessage = message ?? "Invalid invite code"
            }
        }
    }
}

