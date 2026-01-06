import SwiftUI

struct ProfileRow: View {

    let icon: String
    let title: String
    let badge: String?

    init(icon: String, title: String, badge: String? = nil) {
        self.icon = icon
        self.title = title
        self.badge = badge
    }

    var body: some View {
        HStack(spacing: 14) {

            // MARK: - Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue.opacity(0.15))
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .semibold))
            }

            // MARK: - Title
            Text(title)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()

            // MARK: - Badge
            if let badge {
                Text(badge)
                    .font(.caption2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            // MARK: - Chevron
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.footnote)
        }
        .padding()
        .background(
            Color(.secondarySystemGroupedBackground) // ✅ dark mode safe
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

