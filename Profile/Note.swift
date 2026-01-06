import Foundation

struct Note: Identifiable, Codable, Hashable {
    let id: Int
    let title: String
    let content: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case content
        case createdAt = "created_at"
    }
}
