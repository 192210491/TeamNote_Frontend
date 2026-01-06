import SwiftUI

struct TimelineCard: View {
    let item: ActivityTimelineItem
    let index: Int
    let total: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // MARK: - Header
            HStack(spacing: 14) {
                Circle()
                    .fill(Color.white.opacity(0.25))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Text(item.initial)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(item.time)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.75))
                }
            }

            // MARK: - Message
            Text(item.message)
                .font(.body)
                .foregroundColor(.white)
                .padding(14)
                .background(
                    Color.white.opacity(0.18)
                )
                .cornerRadius(16)

            // MARK: - Status
            HStack {
                statusChip(
                    text: item.status == .completed ? "Completed" : "In Progress",
                    icon: item.status == .completed ? "checkmark.circle.fill" : "clock.fill",
                    color: item.status == .completed ? .green : .blue
                )

                Spacer()
            }

            Spacer()

            // MARK: - Footer Index
            Text("\(index + 1) of \(total)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 360)
        .background(
            LinearGradient(
                colors: [
                    Color.black.opacity(0.45),
                    Color.black.opacity(0.25)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(Color.white.opacity(0.12), lineWidth: 1)
        )
        .cornerRadius(28)
    }

    // MARK: - Status Chip
    private func statusChip(text: String, icon: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text)
        }
        .font(.caption)
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(color.opacity(0.9))
        .foregroundColor(.white)
        .cornerRadius(20)
    }
}

