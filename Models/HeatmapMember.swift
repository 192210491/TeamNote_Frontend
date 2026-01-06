import SwiftUI

struct HeatmapMember: Identifiable {
    let id = UUID()
    let name: String
    let days: [HeatmapDay]
}

