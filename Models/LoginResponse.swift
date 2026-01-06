import Foundation

struct LoginResponse: Codable {
    let success: Bool
    let user_id: Int?
    let name: String?
    let email: String?
    let phone: String?
    let bio: String?
    let profile_image: String?
    let message: String?
}
