import SwiftUI

struct TermsConditionsView: View {

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {

                Text("Terms & Conditions")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)

                section(
                    title: "1. Acceptance of Terms",
                    body: "By creating an account and using TeamNote, you agree to comply with these terms."
                )

                section(
                    title: "2. User Responsibilities",
                    body: "You are responsible for maintaining the confidentiality of your account and activities performed under it."
                )

                section(
                    title: "3. Group Usage",
                    body: "Groups are intended for collaboration. Any misuse, abuse, or illegal activity may result in account suspension."
                )

                section(
                    title: "4. Data Storage",
                    body: "Your group data, activity updates, and profile information are stored securely and used only to improve your experience."
                )

                section(
                    title: "5. Termination",
                    body: "We reserve the right to suspend or terminate accounts that violate our policies."
                )

                Spacer(minLength: 20)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Terms & Conditions")
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

