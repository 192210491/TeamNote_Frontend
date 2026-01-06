import SwiftUI

struct SettingsNavRow: View {
    let title: String
    let icon: String
    var trailingText: String? = nil

    var body: some View {
        HStack(spacing: 14) {

            // MARK: - Icon
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.blue)
                .frame(width: 36, height: 36)
                .background(
                    Color.blue.opacity(0.15)
                )
                .cornerRadius(10)

            // MARK: - Title
            Text(title)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()

            // MARK: - Trailing
            if let trailingText {
                Text(trailingText)
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            Color(.secondarySystemGroupedBackground) // ✅ dark-mode safe
        )
        .cornerRadius(18)
        .shadow(
            color: Color.black.opacity(0.15), // 🔥 lighter, iOS-like
            radius: 6,
            x: 0,
            y: 3
        )
        .padding(.horizontal)
    }
}

