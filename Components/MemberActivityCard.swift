import SwiftUI

struct MemberActivityCard: View {

    let member: HeatmapMember

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // MARK: - Title
            HStack {
                Text("\(member.name)’s Activity")
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()
            }

            // MARK: - Heatmap Grid
            HeatmapGridView(days: member.days)

            // MARK: - Legend
            HStack(spacing: 10) {

                Text("Less")
                    .font(.caption)
                    .foregroundColor(.secondary)

                ForEach(0..<5, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(heatmapColor(i))
                        .frame(width: 14, height: 14)
                }

                Text("More")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black.opacity(0.04))
        )
    }
}

