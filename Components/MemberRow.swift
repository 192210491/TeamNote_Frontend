import SwiftUI

struct MemberRow: View {

    let name: String
    let role: String
    let score: Int
    let canRemove: Bool
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 14) {

            // Avatar
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 46, height: 46)
                .overlay(
                    Text(String(name.prefix(1)))
                        .font(.headline)
                        .foregroundColor(.white)
                )

            // Name + Role
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(name)
                        .font(.headline)

                    if role == "Owner" {
                        Text("OWNER")
                            .font(.caption2)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.orange.opacity(0.2))
                            .foregroundColor(.orange)
                            .cornerRadius(8)
                    }
                }

                Text(role)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Score
            VStack(alignment: .trailing) {
                Text("\(score)")
                    .font(.headline)
                Text("Score")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            // ❌ REMOVE BUTTON (OWNER ONLY)
            if canRemove {
                Button(action: onRemove) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding(8)
                        .background(Color.red.opacity(0.15))
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
    }
}
