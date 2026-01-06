import Foundation

enum AppRoute: Hashable {
    case createGroup
    case addUpdate
    case timeline
    case heatmap
    case groupDetail(groupID: UUID)   // ✅ FIXED
}

