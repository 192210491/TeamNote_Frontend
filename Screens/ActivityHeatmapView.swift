import SwiftUI

// MARK: - Activity Heatmap Screen (FINAL + COMPILER SAFE)

struct ActivityHeatmapView: View {

    @EnvironmentObject var activityStore: ActivityStore
    @EnvironmentObject var groupStore: GroupStore

    @State private var selectedMemberIndex: Int = 0

    // MARK: - Derived Data
    private var members: [GroupMember] {
        groupStore.currentGroup?.members ?? []
    }

    private var selectedMember: GroupMember? {
        guard members.indices.contains(selectedMemberIndex) else { return nil }
        return members[selectedMemberIndex]
    }

    // MARK: - BODY
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {

                titleSection

                if members.isEmpty {
                    emptyState
                } else {
                    memberSelector

                    if let groupId = groupStore.selectedGroupId,
                       let member = selectedMember {

                        statsSection(
                            store: activityStore,
                            groupId: groupId,
                            member: member
                        )

                        heatmapSection(
                            groupId: groupId,
                            member: member
                        )
                    }
                }
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .onChange(of: groupStore.selectedGroupId) { _ in
            selectedMemberIndex = 0
        }
    }

    // MARK: - TITLE
    private var titleSection: some View {
        Text("Activity Overview")
            .font(.title2)
            .bold()
    }

    // MARK: - EMPTY STATE
    private var emptyState: some View {
        Text("No members in this group yet.")
            .foregroundColor(.secondary)
            .padding(.top, 20)
    }

    // MARK: - MEMBER SELECTOR
    private var memberSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(members.enumerated()), id: \.offset) { index, member in
                    Button {
                        withAnimation(.easeInOut) {
                            selectedMemberIndex = index
                        }
                    } label: {
                        Text(member.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .foregroundColor(selectedMemberIndex == index ? .white : .primary)
                            .background(
                                selectedMemberIndex == index
                                ? AnyShapeStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                  )
                                : AnyShapeStyle(Color(.secondarySystemBackground))
                            )

                            .cornerRadius(18)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 4)
        }
    }


    // MARK: - STATS SECTION
    private func statsSection(
        store: ActivityStore,
        groupId: Int,
        member: GroupMember
    ) -> some View {

        HStack(spacing: 16) {

            StatCard(
                icon: "flame.fill",
                title: "Current Streak",
                value: "\(store.streak(groupId: groupId, memberId: member.id))",
                color: .orange
            )

            StatCard(
                icon: "chart.bar.fill",
                title: "Avg Score",
                value: "\(store.score(groupId: groupId, memberId: member.id))",
                color: .blue
            )

        }
    }

    // MARK: - HEATMAP SECTION
    private func heatmapSection(
        groupId: Int,
        member: GroupMember
    ) -> some View {

        VStack(alignment: .leading, spacing: 14) {

            Text("\(member.name)’s Activity")
                .font(.headline)

            MemberActivityCard(
                member: HeatmapMember(
                    name: member.name,
                    days: activityStore.heatmapDays(
                        groupId: groupId,
                        memberId: member.id
                    )
                )
            )
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(22)
    }
}

