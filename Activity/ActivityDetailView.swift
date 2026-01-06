import SwiftUI

struct ActivityDetailView: View {

    @EnvironmentObject var activityStore: ActivityStore   // ✅ REQUIRED
    @AppStorage("userId") private var currentUserId: Int = 0
    let update: ActivityUpdate
    let currentUserName: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Header
                HStack(spacing: 14) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.pink, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)
                        .overlay(
                            Text(String(update.name.prefix(1)))
                                .foregroundColor(.white)
                                .font(.headline)
                        )

                    VStack(alignment: .leading, spacing: 4) {
                        Text(update.name)
                            .font(.headline)
                        Text(update.time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }

                Text(update.message)
                    .padding()
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(18)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Update")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
           
            if update.memberId == currentUserId {

                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        EditUpdateView(update: update)
                            .environmentObject(activityStore)   // ✅ THIS FIXES ERROR
                    } label: {
                        Text("Edit").bold()
                    }
                }
            }
        }
    }
}

