import SwiftUI
import Combine

@MainActor
final class UpdateStore: ObservableObject {

    @Published var updates: [ActivityUpdate] = []
    @Published var isLoading = false

    private let baseURL = "http://localhost/teamnote_api/updates"

    func fetchUpdates(groupId: Int) {
        isLoading = true

        let url = URL(string: "\(baseURL)/get_group_updates.php?group_id=\(groupId)")!

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data else {
                self.isLoading = false
                return
            }

            do {
                let decoded = try JSONDecoder()
                    .decode(UpdatesResponse.self, from: data)

                guard decoded.success else {
                    self.isLoading = false
                    return
                }

                self.updates = decoded.updates.map {
                    ActivityUpdate(dto: $0)
                }

                self.isLoading = false

            } catch {
                print("❌ Update decode error:", error)
                self.isLoading = false
            }
        }.resume()
    }

    func clear() {
        updates.removeAll()
    }
}

