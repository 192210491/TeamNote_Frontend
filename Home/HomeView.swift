import SwiftUI

// MARK: - UI Helpers (VISIBLE TO HomeView)

func quickAction(title: String, icon: String, color: Color) -> some View {
    VStack(spacing: 12) {
        Image(systemName: icon)
            .font(.system(size: 26))
            .foregroundColor(.white)
            .frame(width: 56, height: 56)
            .background(color)
            .cornerRadius(16)

        Text(title)
            .font(.system(size: 15))
            .foregroundColor(.primary)
    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(Color(.secondarySystemBackground))
    .cornerRadius(20)
    .shadow(color: .black.opacity(0.08), radius: 10)
}

func groupCard(
    title: String,
    subtitle: String,
    members: String,
    lastUpdate: String
) -> some View {
    VStack(alignment: .leading, spacing: 8) {

        HStack {
            Text(title)
                .font(.headline)

            Spacer()

            Text(members)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }

        Text(subtitle)
            .font(.subheadline)
            .foregroundColor(.secondary)

        HStack {
            Text("Last update: \(lastUpdate)")
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()

            Text("Active")
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.green.opacity(0.2))
                .foregroundColor(.green)
                .cornerRadius(12)
        }
    }
    .padding()
    .background(Color(.secondarySystemBackground))
    .cornerRadius(20)
}

func summaryBox(value: String, label: String, color: Color) -> some View {
    VStack(spacing: 6) {
        Text(value)
            .font(.title2)
            .bold()
            .foregroundColor(color)

        Text(label)
            .font(.caption)
            .foregroundColor(.secondary)
    }
    .frame(maxWidth: .infinity)
    .padding()
    .background(Color(.secondarySystemBackground))
    .cornerRadius(16)
}

func recentUpdate(name: String, message: String, time: String) -> some View {
    HStack(spacing: 12) {
        Circle()
            .fill(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 44, height: 44)
            .overlay(
                Text(String(name.prefix(1)))
                    .foregroundColor(.white)
                    .bold()
            )

        VStack(alignment: .leading, spacing: 4) {
            Text(name).bold()
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }

        Spacer()

        Text(time)
            .font(.caption)
            .foregroundColor(.secondary)
    }
    .padding()
    .background(Color(.secondarySystemBackground))
    .cornerRadius(16)
}

// MARK: - Routes

enum HomeRoute: Hashable {
    case createGroup
    case addUpdate
    case timeline
    case heatmap
    case groupDetail(Int)
}

// MARK: - Home View

struct HomeView: View {

    @State private var path: [HomeRoute] = []

    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var activityStore: ActivityStore

    var body: some View {

        NavigationStack(path: $path) {

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: - Quick Actions
                    Text("Quick Actions")
                        .font(.headline)
                        .padding(.horizontal)

                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 20
                    ) {
                        quickAction(title: "Create Group", icon: "person.3", color: .blue)
                            .onTapGesture { path.append(.createGroup) }

                        quickAction(title: "Add Update", icon: "plus", color: .purple)
                            .onTapGesture {
                                if groupStore.selectedGroupId != nil {
                                    path.append(.addUpdate)
                                } else {
                                    path.append(.createGroup)
                                }
                            }

                        quickAction(title: "View Analytics", icon: "arrow.up.right", color: .indigo)
                            .onTapGesture { path.append(.heatmap) }

                        quickAction(title: "Timeline", icon: "calendar", color: .pink)
                            .onTapGesture { path.append(.timeline) }
                    }
                    .padding(.horizontal)

                    // MARK: - Groups
                    HStack {
                        Text("Your Groups")
                            .font(.title3)
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)

                    VStack(spacing: 16) {
                        ForEach(groupStore.groups) { group in
                            groupCard(
                                title: group.name,
                                subtitle: group.description ?? "",
                                members: "\(group.members.count) members",
                                lastUpdate: "Recently updated"
                            )
                            .onTapGesture {
                                groupStore.selectGroup(group.id)
                                path.append(.groupDetail(group.id))
                            }
                        }
                    }
                    .padding(.horizontal)

                    // MARK: - Summary
                    Text("Today's Summary")
                        .font(.headline)
                        .padding(.horizontal)

                    HStack(spacing: 20) {
                        summaryBox(
                            value: "\(activityStore.totalUpdates)",
                            label: "Updates",
                            color: .blue
                        )
                        summaryBox(
                            value: "\(activityStore.completedCount)",
                            label: "Completed",
                            color: .green
                        )
                        summaryBox(
                            value: "\(activityStore.pendingCount)",
                            label: "Pending",
                            color: .orange
                        )
                    }
                    .padding(.horizontal)

                    // MARK: - Recent Updates
                    Text("Recent Updates")
                        .font(.headline)
                        .padding(.horizontal)

                    VStack(spacing: 14) {
                        ForEach(activityStore.updates.prefix(5)) { update in
                            NavigationLink {
                                ActivityDetailView(
                                    update: update,
                                    currentUserName: "Omkar"
                                )
                            } label: {
                                recentUpdate(
                                    name: update.name,
                                    message: update.message,
                                    time: update.time
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .background(Color(.systemBackground))

            // 🔥 SYNC WHEN GROUP CHANGES
            .onAppear {
                if let groupId = groupStore.selectedGroupId {
                    activityStore.fetchTimeline(groupId: groupId)
                }
            }
            .onChange(of: groupStore.selectedGroupId) { newGroupId in
                if let id = newGroupId {
                    activityStore.fetchTimeline(groupId: id)
                }
            }

            .navigationDestination(for: HomeRoute.self) { route in
                switch route {

                case .createGroup:
                    CreateGroupView()

                case .timeline:
                    ActivityTimelineView()
                        .environmentObject(activityStore)

                case .heatmap:
                    ActivityHeatmapView()
                        .environmentObject(activityStore)
                        .environmentObject(groupStore)

                case .groupDetail(let id):
                    GroupDetailWrapperView(groupID: id)

                default:
                    EmptyView()   // ✅ FIXES EXHAUSTIVE ERROR
                }
            }


            }
        }
    }

