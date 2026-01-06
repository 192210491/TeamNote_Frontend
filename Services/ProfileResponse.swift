struct ProfileResponse: Codable {
    let success: Bool
    let user: UserProfile?
}

struct UserProfile: Codable {
    let id: Int
    let name: String
    let email: String
    let phone: String?
    let bio: String?
    let profile_image: String?
}
