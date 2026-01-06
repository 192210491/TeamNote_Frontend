import SwiftUI

struct NotificationCard: View {
    let icon: String
    let color: Color
    let title: String
    let message: String
    let time: String

    var body: some View {
        HStack(alignment: .top, spacing: 16) {

            // MARK: - Icon
            Image(systemName: icon)
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(color)
                .cornerRadius(14)

            // MARK: - Content
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(
            Color(.secondarySystemGroupedBackground) // ✅ dark-mode safe
        )
        .cornerRadius(18)
        .shadow(
            color: Color.black.opacity(0.25),
            radius: 8,
            x: 0,
            y: 4
        )
    }
}

