import Foundation

class NotesService {

    static let shared = NotesService()
    private init() {}

    private let baseURL = "http://localhost/teamnote_api"

    // MARK: - FETCH
    func fetchNotes(
        userId: Int,
        completion: @escaping (Result<[Note], Error>) -> Void
    ) {
        let url = URL(string: "\(baseURL)/notes/list.php?user_id=\(userId)")!

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(NotesResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(response.notes))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    // MARK: - CREATE
    func createNote(
        userId: Int,
        title: String,
        content: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        var request = URLRequest(url: URL(string: "\(baseURL)/notes/create.php")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "user_id": userId,
            "title": title,
            "content": content
        ])

        URLSession.shared.dataTask(with: request) { _, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(true))
                }
            }
        }.resume()
    }

    // MARK: - UPDATE
    func updateNote(
        noteId: Int,
        title: String,
        content: String,
        completion: @escaping (Bool) -> Void
    ) {
        var request = URLRequest(url: URL(string: "\(baseURL)/notes/update.php")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "id": noteId,
            "title": title,
            "content": content
        ])

        URLSession.shared.dataTask(with: request) { _, _, error in
            DispatchQueue.main.async {
                completion(error == nil)
            }
        }.resume()
    }

    // MARK: - DELETE
    func deleteNote(
        noteId: Int,
        completion: @escaping (Bool) -> Void
    ) {
        var request = URLRequest(url: URL(string: "\(baseURL)/notes/delete.php")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            "id": noteId
        ])

        URLSession.shared.dataTask(with: request) { _, _, error in
            DispatchQueue.main.async {
                completion(error == nil)
            }
        }.resume()
    }
}

// MARK: - RESPONSE
struct NotesResponse: Codable {
    let success: Bool
    let notes: [Note]
}

