import Foundation

struct UpdatesResponse: Codable {
    let success: Bool
    let updates: [ActivityUpdateDTO]
}

