import SwiftUI

struct GroupsView: View {

    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var activityStore: ActivityStore

    @State private var showCreate = false
    @State private var showJoin = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {

                    // MARK: - Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your Groups")
                                .font(.title2)
                                .bold()

                            Text("Manage your team groups")
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        // 🔑 JOIN GROUP
                        Button {
                            showJoin = true
                        } label: {
                            Image(systemName: "person.badge.plus")
                                .foregroundColor(.blue)
                                .frame(width: 44, height: 44)
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(14)
                        }

                        // ➕ CREATE GROUP
                        Button {
                            showCreate = true
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .cornerRadius(14)
                        }
                    }

                    // MARK: - Groups List
                    if groupStore.groups.isEmpty {
                        Text("You are not part of any group yet.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 40)
                    } else {
                        ForEach(groupStore.groups) { group in
                            NavigationLink {
                                GroupDetailWrapperView(groupID: group.id)
                                    .environmentObject(groupStore)
                                    .environmentObject(activityStore)
                            } label: {
                                GroupCard(
                                    name: group.name,
                                    members: group.membersCount, // ✅ use backend count
                                    description: group.description ?? "",
                                    lastUpdate: "Just now",
                                    isActive: true
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding()
            }

            // MARK: - Create Group
            .sheet(isPresented: $showCreate) {
                CreateGroupView()
                    .environmentObject(groupStore)
                    .environmentObject(activityStore)
            }

            // MARK: - Join Group
            .sheet(isPresented: $showJoin) {
                JoinGroupView()
                    .environmentObject(groupStore)
            }
        }
    }
}

