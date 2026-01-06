import SwiftUI

struct ActivityTimelineItem: Identifiable {
    let id = UUID()
    let name: String
    let initial: String
    let message: String
    let status: TaskStatus
    let time: String
}

