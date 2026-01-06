import Foundation

class ForgotPasswordService {

    static let shared = ForgotPasswordService()
    private init() {}

    let baseURL = "http://localhost/teamnote_api"


    func sendOTP(
        email: String,
        completion: @escaping (Result<Bool, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/auth/forgot_password.php") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["email": email]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else { return }

            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            let success = json?["success"] as? Bool ?? false

            DispatchQueue.main.async {
                completion(.success(success))
            }
        }.resume()
    }
}

