import SwiftUI

struct InviteView: View {

    let inviteCode: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {

            Text("Invite Members")
                .font(.title2)
                .bold()

            Text("Share this code with your teammates to let them join your group.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            // Invite Code Box
            Text(inviteCode)
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(16)

            // Copy Button
            Button {
                UIPasteboard.general.string = inviteCode
            } label: {
                Label("Copy Invite Code", systemImage: "doc.on.doc")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(16)
            }

            Spacer()

            Button("Close") {
                dismiss()
            }
            .foregroundColor(.secondary)
        }
        .padding()
    }
}

