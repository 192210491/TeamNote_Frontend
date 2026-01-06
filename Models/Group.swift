import Foundation

// MARK: - Group Model (MATCHES BACKEND RESPONSE)
struct Group: Identifiable, Codable {

    // Backend ID
    let id: Int

    let name: String
    let description: String?
    let inviteCode: String

    // FULL members list (from backend)
    let members: [GroupMember]

    // Derived (UI convenience)
    var membersCount: Int {
        members.count
    }
}

// MARK: - Group Member
struct GroupMember: Identifiable, Codable {

    let id: Int
    let name: String
    let role: String   // "Owner" | "Member"
    let score: Int
}

