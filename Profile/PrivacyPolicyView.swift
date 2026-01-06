import SwiftUI

struct PrivacyPolicyView: View {

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {

                Text("Privacy Policy")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)

                section(
                    title: "1. Information We Collect",
                    body: "TeamNote collects basic profile information such as name and activity updates you choose to share within groups."
                )

                section(
                    title: "2. How We Use Your Data",
                    body: "Your data is used only to enable collaboration features like activity tracking, heatmaps, and group insights."
                )

                section(
                    title: "3. Data Sharing",
                    body: "We do not sell, trade, or share your personal data with third parties."
                )

                section(
                    title: "4. Group Visibility",
                    body: "Your updates are visible only to members within the same group."
                )

                section(
                    title: "5. Data Security",
                    body: "We take reasonable measures to protect your data against unauthorized access or loss."
                )

                section(
                    title: "6. Account Deletion",
                    body: "If you delete your account, your personal data will be permanently removed from our systems."
                )

                section(
                    title: "7. Policy Updates",
                    body: "This policy may be updated periodically. Continued use of the app implies acceptance of the revised policy."
                )

                Spacer(minLength: 20)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Reusable Section
    private func section(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)

            Text(body)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

