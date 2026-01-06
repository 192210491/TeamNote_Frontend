import SwiftUI

struct HomeProfileView: View {
    var body: some View {
        VStack(spacing: 24) {

            // MARK: Profile Header
            VStack(spacing: 6) {
                Text("Omkar")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text("omkar@teamnote.app")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top, 20)

            // MARK: Stats
            HStack(spacing: 16) {
                StatCard(
                    icon: "rosette",
                    title: "Score",
                    value: "92",
                    color: .blue
                )

                StatCard(
                    icon: "target",
                    title: "Updates",
                    value: "156",
                    color: .green
                )

                StatCard(
                    icon: "bolt.fill",
                    title: "Streak",
                    value: "12",
                    color: .purple
                )
            }
            .padding(.horizontal)

            Spacer()
        }
    }
}

