import SwiftUI

enum TaskStatus: String, CaseIterable {
    case todo = "To-Do"
    case inProgress = "In Progress"
    case completed = "Completed"

    var color: Color {
        switch self {
        case .todo: return .orange
        case .inProgress: return .blue
        case .completed: return .green
        }
    }
}

