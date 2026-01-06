import SwiftUI

struct NotificationsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                NotificationCard(
                    icon: "bell.fill",
                    color: .blue,
                    title: "New update from Priya",
                    message: "Completed dashboard redesign",
                    time: "10m ago"
                )

                NotificationCard(
                    icon: "bolt.fill",
                    color: .green,
                    title: "Streak milestone!",
                    message: "You have maintained a 7-day streak",
                    time: "1 day ago"
                )

                NotificationCard(
                    icon: "person.fill",
                    color: .purple,
                    title: "Group invite",
                    message: "You were added to Mobile Team",
                    time: "2 days ago"
                )

                NotificationCard(
                    icon: "gearshape.fill",
                    color: .orange,
                    title: "Message from owner",
                    message: "Team meeting scheduled for tomorrow",
                    time: "3 days ago"
                )
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground)) // ✅ consistent
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

