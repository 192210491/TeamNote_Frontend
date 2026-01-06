import SwiftUI

struct CreateGroupView: View {

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var groupStore: GroupStore

    @AppStorage("currentUserName")
    private var currentUserName: String = "Omkar"

    @State private var name = ""
    @State private var description = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                Text("Create New Group")
                    .font(.title2)
                    .bold()

                // MARK: - Group Name
                TextField("Group Name", text: $name)
                    .textFieldStyle(.roundedBorder)

                // MARK: - Description
                TextField("Description", text: $description)
                    .textFieldStyle(.roundedBorder)

                // MARK: - Info
                Text("You can invite members after creating the group.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // MARK: - Create Group
                Button {
                    let trimmedName = name.trimmingCharacters(in: .whitespaces)
                    guard !trimmedName.isEmpty else { return }

                    // ✅ OWNER-ONLY GROUP CREATION
                    groupStore.createGroup(
                        name: trimmedName,
                        description: description
                    ) { success in
                        if success {
                            dismiss()
                        }
                    }

                } label: {
                    Text("Create Group")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                }
            }
            .padding()
        }
    }
}

