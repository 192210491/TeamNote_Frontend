import Foundation

struct ActivityUpdateDTO: Codable {

    let id: Int
    let group_id: Int
    let user_id: Int
    let user_name: String
    let content_type: String
    let message: String
    let created_at: String
}

