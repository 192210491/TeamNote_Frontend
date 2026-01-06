import SwiftUI

struct ActivityUpdate: Identifiable, Equatable {

    // ✅ SINGLE SOURCE OF TRUTH (LIKE NOTE.ID)
    let id: Int            // backend activity_updates.id

    // MARK: - Display
    let name: String

    // MARK: - Relations
    let groupId: Int
    let memberId: Int

    // MARK: - Content
    let createdAt: Date
    let contentType: UpdateContentType
    var message: String
    var status: TaskStatus
    var time: String

    // MARK: - Equatable (simple + safe)
    static func == (lhs: ActivityUpdate, rhs: ActivityUpdate) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - DTO → MODEL
extension ActivityUpdate {

    init(dto: ActivityUpdateDTO) {
        self.id = dto.id
        self.name = dto.user_name
        self.groupId = dto.group_id
        self.memberId = dto.user_id
        self.createdAt = Self.parseDate(dto.created_at)
        self.contentType = UpdateContentType(rawValue: dto.content_type) ?? .text
        self.message = dto.message
        self.status = .completed
        self.time = Self.formatTime(dto.created_at)
    }

    private static func parseDate(_ value: String) -> Date {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return f.date(from: value) ?? Date()
    }

    private static func formatTime(_ value: String) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: parseDate(value))
    }
}
