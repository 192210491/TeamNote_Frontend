import Foundation

class ResetPasswordService {

    static let shared = ResetPasswordService()
    private init() {}

    // ⚠️ Use SAME base URL you used in ForgotPasswordService
    private let baseURL = "http://localhost/teamnote_api"

    func resetPassword(
        email: String,
        password: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {

        guard let url = URL(
            string: "\(baseURL)/auth/reset_password.php"
        ) else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "email": email,
            "password": password
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, error in

            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.success(false))
                }
                return
            }

            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            let success = json?["success"] as? Bool ?? false

            DispatchQueue.main.async {
                completion(.success(success))
            }

        }.resume()
    }
}

