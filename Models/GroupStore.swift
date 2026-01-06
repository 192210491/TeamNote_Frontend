import SwiftUI
import Combine

@MainActor
final class GroupStore: ObservableObject {

    // MARK: - Stored User
    @AppStorage("userId") private var userId: Int = 0

    // MARK: - Groups
    @Published var groups: [Group] = []

    // MARK: - Selected Group
    @Published var selectedGroupId: Int?

    // MARK: - API Base URL
    private let baseURL = "http://localhost/teamnote_api/groups"

    // MARK: - Init
    init() {
        fetchGroups()
    }

    // MARK: - Current Group
    var currentGroup: Group? {
        groups.first { $0.id == selectedGroupId }
    }

    // MARK: - Select Group (FIXED)
    func selectGroup(_ id: Int) {
        selectedGroupId = id
    }

    // MARK: - Fetch User Groups (FIXED)
    func fetchGroups() {
        guard userId > 0 else { return }

        var request = URLRequest(
            url: URL(string: "\(baseURL)/list.php")!
        )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "user_id": userId
        ])

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data else { return }

            do {
                let response = try JSONDecoder()
                    .decode(GroupListResponse.self, from: data)

                guard response.success else { return }

                Task { @MainActor in
                    self.groups = response.groups

                    // 🔥 AUTO-SELECT FIRST GROUP
                    if self.selectedGroupId == nil,
                       let first = response.groups.first {
                        self.selectedGroupId = first.id
                    }
                }

            } catch {
                print("❌ Group decode error:", error)
            }
        }.resume()
    }

    // MARK: - Join Group
    func joinGroup(
        inviteCode: String,
        completion: @escaping (Bool, String?) -> Void
    ) {
        guard userId > 0 else {
            completion(false, "Invalid user")
            return
        }

        var request = URLRequest(
            url: URL(string: "\(baseURL)/join.php")!
        )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "user_id": userId,
            "invite_code": inviteCode
        ])

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data else {
                Task { @MainActor in completion(false, "Server error") }
                return
            }

            do {
                let response = try JSONDecoder()
                    .decode(JoinGroupResponse.self, from: data)

                Task { @MainActor in
                    if response.success {
                        self.fetchGroups()
                        completion(true, response.message)
                    } else {
                        completion(false, response.message)
                    }
                }
            } catch {
                Task { @MainActor in completion(false, "Invalid response") }
            }
        }.resume()
    }

    // MARK: - Create Group
    func createGroup(
        name: String,
        description: String,
        completion: @escaping (Bool) -> Void
    ) {
        guard userId > 0 else {
            completion(false)
            return
        }

        var request = URLRequest(
            url: URL(string: "\(baseURL)/create.php")!
        )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "name": name,
            "description": description,
            "owner_id": userId
        ])

        URLSession.shared.dataTask(with: request) { _, _, _ in
            Task { @MainActor in
                self.fetchGroups()
                completion(true)
            }
        }.resume()
    }

    // MARK: - Remove Member
    func removeMember(
        groupID: Int,
        memberID: Int,
        completion: @escaping (Bool) -> Void
    ) {
        guard userId > 0 else {
            completion(false)
            return
        }

        var request = URLRequest(
            url: URL(string: "\(baseURL)/remove_member.php")!
        )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "group_id": groupID,
            "user_id": memberID,
            "owner_id": userId
        ])

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data else {
                Task { @MainActor in completion(false) }
                return
            }

            do {
                let response = try JSONDecoder()
                    .decode(SimpleSuccessResponse.self, from: data)

                Task { @MainActor in
                    if response.success {
                        self.fetchGroups()
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            } catch {
                Task { @MainActor in completion(false) }
            }
        }.resume()
    }
}

// MARK: - API Responses

struct GroupListResponse: Codable {
    let success: Bool
    let groups: [Group]
}

struct JoinGroupResponse: Codable {
    let success: Bool
    let group_id: Int?
    let message: String?
}

struct SimpleSuccessResponse: Codable {
    let success: Bool
    let message: String?
}

