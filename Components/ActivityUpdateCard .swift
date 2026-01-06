import SwiftUI

struct ActivityUpdateCard: View {

    let update: ActivityUpdate

    var body: some View {

        VStack(alignment: .leading, spacing: 14) {

            // HEADER
            HStack(spacing: 12) {

                Circle()
                    .fill(update.status.color)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text(String(update.name.prefix(1)))
                            .font(.headline)
                            .foregroundColor(.white)
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

            // MESSAGE
            Text(update.message)
                .font(.body)

            // STATUS
            Text(update.status.rawValue)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(update.status.color.opacity(0.2))
                .foregroundColor(update.status.color)
                .cornerRadius(12)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.15), radius: 6, y: 4)

        // 🔥 CRITICAL LINE (THIS FIXES EVERYTHING)
        .allowsHitTesting(false)
    }
}
