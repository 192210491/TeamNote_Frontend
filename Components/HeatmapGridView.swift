import SwiftUI

struct HeatmapGridView: View {

    let days: [HeatmapDay]

    // Tighter grid for phones
    private let columns = Array(
        repeating: GridItem(.fixed(14), spacing: 4),
        count: 14
    )

    var body: some View {
        LazyVGrid(columns: columns, spacing: 4) {
            ForEach(days) { day in
                RoundedRectangle(cornerRadius: 3)
                    .fill(heatmapColor(day.intensity))
                    .frame(width: 14, height: 14)
            }
        }
    }
}

// MARK: - Heatmap Color Scale (Mobile Friendly)
func heatmapColor(_ intensity: Int) -> Color {
    switch intensity {
    case 0:
        return Color(.systemGray5)          // No activity
    case 1:
        return Color.blue.opacity(0.25)     // Low
    case 2:
        return Color.blue.opacity(0.5)      // Medium
    case 3:
        return Color.green.opacity(0.6)     // High
    default:
        return Color.green                  // Very high
    }
}

