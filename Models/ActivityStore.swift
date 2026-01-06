import SwiftUI
import Combine

@MainActor
final class ActivityStore: ObservableObject {

    @AppStorage("userId") private var userId: Int = 0

    // ✅ SOURCE OF TRUTH (stable for SwiftUI)
    @Published var updates: [ActivityUpdate] = []

    private let baseURL = "http://localhost/teamnote_api/activities"

    // MARK: - CREATE UPDATE
    func createUpdate(
        groupId: Int,
        contentType: UpdateContentType,
        message: String,
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
            "group_id": groupId,
            "user_id": userId,
            "content_type": contentType.rawValue,
            "message": message
        ])

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data else {
                Task { completion(false) }
                return
            }

            do {
                let response = try JSONDecoder()
                    .decode(CreateUpdateResponse.self, from: data)

                Task { completion(response.success) }
            } catch {
                Task { completion(false) }
            }
        }.resume()
    }

    // MARK: - FETCH TIMELINE (🔥 FIXED – STABLE ID)
    func fetchTimeline(groupId: Int) {
        guard userId > 0 else { return }

        var request = URLRequest(
            url: URL(string: "\(baseURL)/list.php")!
        )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "group_id": groupId
        ])

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data else { return }

            do {
                let response = try JSONDecoder()
                    .decode(ActivityListResponse.self, from: data)

                guard response.success else { return }

                Task { @MainActor in
                    self.updates = response.activities.map { backend in
                        ActivityUpdate(
                            id: backend.id,                    // ✅ backend primary key
                            name: backend.name,
                            groupId: backend.group_id,
                            memberId: backend.user_id,
                            createdAt: Self.parseDate(backend.created_at),
                            contentType: UpdateContentType(
                                rawValue: backend.content_type
                            ) ?? .text,
                            message: backend.message,
                            status: .completed,
                            time: Self.formatTime(backend.created_at)
                        )

                    }
                }

            } catch {
                print("❌ fetchTimeline error:", error)
            }
        }.resume()
    }

    // MARK: - EDIT (LOCAL + SERVER)
    // MARK: - EDIT (LOCAL + SERVER)
    func updateExisting(_ updated: ActivityUpdate) {
        guard let index = updates.firstIndex(where: {
            $0.id == updated.id
        }) else { return }

        updates[index] = updated
    }

    func syncEditUpdate(_ update: ActivityUpdate) {
        guard userId > 0 else { return }

        var request = URLRequest(
            url: URL(string: "\(baseURL)/edit.php")!
        )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "update_id": update.id,              // ✅ ONLY ID
            "user_id": userId,
            "message": update.message,
            "status": update.status.rawValue
        ])

        URLSession.shared.dataTask(with: request).resume()
    }

    // MARK: - DELETE (OWNER ONLY)
    func deleteUpdate(_ update: ActivityUpdate) {
        guard userId > 0 else { return }

        var request = URLRequest(
            url: URL(string: "\(baseURL)/delete.php")!
        )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "update_id": update.id,               // ✅ ONLY ID
            "user_id": userId
        ])

        URLSession.shared.dataTask(with: request) { _, _, _ in
            Task { @MainActor in
                self.updates.removeAll { $0.id == update.id }
            }
        }.resume()
    }


    // MARK: - SUMMARY
    var totalUpdates: Int { updates.count }
    var completedCount: Int { updates.filter { $0.status == .completed }.count }
    var pendingCount: Int { updates.filter { $0.status != .completed }.count }
}

// MARK: - Backend Models

struct ActivityListResponse: Codable {
    let success: Bool
    let activities: [ActivityBackendItem]
}

struct ActivityBackendItem: Codable {
    let id: Int
    let group_id: Int
    let user_id: Int
    let name: String
    let content_type: String
    let message: String
    let created_at: String
}

struct CreateUpdateResponse: Codable {
    let success: Bool
    let id: Int
}

// MARK: - DATE HELPERS (SAFE)

extension ActivityStore {

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

// MARK: - HEATMAP + STATS (UNCHANGED)

extension ActivityStore {

    private func updates(
        groupId: Int,
        memberId: Int
    ) -> [ActivityUpdate] {
        updates.filter {
            $0.groupId == groupId &&
            $0.memberId == memberId
        }
    }

    func streak(groupId: Int, memberId: Int) -> Int {
        updates(groupId: groupId, memberId: memberId).count
    }

    func score(groupId: Int, memberId: Int) -> Int {
        updates(groupId: groupId, memberId: memberId).count * 10
    }

    func heatmapDays(
        groupId: Int,
        memberId: Int
    ) -> [HeatmapDay] {

        let memberUpdates = updates(
            groupId: groupId,
            memberId: memberId
        )

        let grouped = Dictionary(grouping: memberUpdates) {
            Calendar.current.startOfDay(for: $0.createdAt)
        }

        return grouped.map { date, updates in
            HeatmapDay(
                date: date,
                intensity: updates.count
            )
        }
    }
}
