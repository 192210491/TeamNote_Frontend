import SwiftUI

struct GroupDetailView: View {

    @EnvironmentObject var groupStore: GroupStore
    let groupID: Int

    @AppStorage("userId") private var currentUserId: Int = 0
    @State private var showInvite = false

    // 🔴 LIVE GROUP (auto refresh after delete)
    private var group: Group? {
        groupStore.groups.first { $0.id == groupID }
    }

    // 🔴 OWNER CHECK (correct)
    private var isOwner: Bool {
        group?.members.contains {
            $0.role == "Owner" && $0.id == currentUserId
        } ?? false
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {

                // MARK: - Header
                Text(group?.name ?? "")
                    .font(.title)
                    .bold()

                Text(group?.description ?? "")
                    .foregroundColor(.secondary)

                // MARK: - Invite
                HStack {
                    Label(
                        "Code: \(group?.inviteCode ?? "")",
                        systemImage: "doc.on.doc"
                    )
                    .padding(12)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)

                    Spacer()

                    Button("Invite") {
                        showInvite = true
                    }
                    .disabled(!isOwner)
                    .opacity(isOwner ? 1 : 0.4)
                }

                // MARK: - Members
                Text("Members (\(group?.members.count ?? 0))")
                    .font(.headline)

                VStack(spacing: 14) {
                    ForEach(group?.members ?? []) { member in
                        MemberRow(
                            name: member.name,
                            role: member.role,
                            score: member.score,
                            canRemove: isOwner && member.role != "Owner",
                            onRemove: {
                                groupStore.removeMember(
                                    groupID: groupID,
                                    memberID: member.id
                                ) { success in
                                    if !success {
                                        print("❌ Remove failed")
                                    }
                                }
                            }
                        )
                    }
                }

                Text("Members will appear in activity after they post updates.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .sheet(isPresented: $showInvite) {
            InviteView(inviteCode: group?.inviteCode ?? "")
        }
    }
}

