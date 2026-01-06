import Foundation

class AuthService {

    static let shared = AuthService()
    private init() {}

    private let baseURL = "http://localhost/teamnote_api"

    // MARK: - LOGIN
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<LoginResponse, Error>) -> Void
    ) {

        guard let url = URL(string: "\(baseURL)/auth/login.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = [
            "email": email,
            "password": password
        ]

        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else { return }

                do {
                    let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    // MARK: - REGISTER
    func register(
        name: String,
        email: String,
        phone: String,
        password: String,
        completion: @escaping (Result<RegisterResponse, Error>) -> Void
    ) {

        guard let url = URL(string: "\(baseURL)/auth/register.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "name": name,
            "email": email,
            "phone": phone,
            "password": password
        ]

        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else { return }

                do {
                    let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }

    // MARK: - FETCH PROFILE (🔥 CRITICAL)
    func fetchProfile(
        userId: Int,
        completion: @escaping (Result<UserProfile, Error>) -> Void
    ) {

        guard let url = URL(
            string: "\(baseURL)/profile/get.php?user_id=\(userId)"
        ) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            DispatchQueue.main.async {

                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else { return }

                do {
                    let response = try JSONDecoder().decode(ProfileResponse.self, from: data)
                    if let user = response.user {
                        completion(.success(user))
                    } else {
                        completion(
                            .failure(
                                NSError(
                                    domain: "Profile",
                                    code: 0,
                                    userInfo: [NSLocalizedDescriptionKey: "User not found"]
                                )
                            )
                        )
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
