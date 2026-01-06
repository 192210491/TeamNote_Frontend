import SwiftUI

struct LoginView: View {

    @Binding var path: [AuthRoute]

    // 🔑 SINGLE SOURCE OF TRUTH
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("userId") private var userId: Int = 0

    @AppStorage("currentUserName") private var currentUserName: String = ""
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    @AppStorage("currentUserPhone") private var currentUserPhone: String = ""
    @AppStorage("currentUserBio") private var currentUserBio: String = ""
    @AppStorage("currentUserProfileImage") private var currentUserProfileImage: String = ""

    // UI State
    @State private var email = "bharathpendela@gmail.com"
    @State private var password = "bharathtest"
    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {
        ZStack {

            LinearGradient(
                colors: [
                    Color.black,
                    Color.purple.opacity(0.85),
                    Color.pink.opacity(0.75)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                VStack(spacing: 22) {

                    VStack(spacing: 6) {
                        Text("Welcome Back")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("Login to continue to TeamNote")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    inputField(
                        icon: "envelope.fill",
                        placeholder: "Email",
                        text: $email,
                        isSecure: false
                    )

                    inputField(
                        icon: "lock.fill",
                        placeholder: "Password",
                        text: $password,
                        isSecure: true
                    )

                    HStack {
                        Spacer()
                        Button("Forgot Password?") {
                            path.append(.forgotPassword)
                        }
                        .font(.footnote)
                        .foregroundColor(.blue)
                    }

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    Button {
                        login()
                    } label: {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(
                                    CircularProgressViewStyle(tint: .white)
                                )
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                        } else {
                            Text("Login")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 54)
                        }
                    }
                    .background(
                        LinearGradient(
                            colors: [.blue, .purple, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(20)
                    .shadow(color: Color.black.opacity(0.3), radius: 10, y: 6)
                    .padding(.top, 8)
                    .disabled(isLoading)

                    HStack(spacing: 6) {
                        Text("Don’t have an account?")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        Button("Sign Up") {
                            path.append(.signup)
                        }
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    }
                }
                .padding(28)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(30)
                .shadow(color: Color.black.opacity(0.35), radius: 20, y: 10)
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }

    // MARK: - LOGIN (FINAL & FIXED)
    private func login() {

        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please fill all fields"
            return
        }

        errorMessage = ""
        isLoading = true

        AuthService.shared.login(email: email, password: password) { result in
            DispatchQueue.main.async {

                switch result {
                case .success(let response):

                    guard
                        response.success,
                        let id = response.user_id
                    else {
                        isLoading = false
                        errorMessage = "Invalid email or password"
                        return
                    }

                    // 🔥 CLEAR PREVIOUS USER COMPLETELY
                    userId = 0
                    currentUserName = ""
                    currentUserEmail = ""
                    currentUserPhone = ""
                    currentUserBio = ""
                    currentUserProfileImage = ""

                    // 🔑 STORE USER ID
                    userId = id

                    // 🔥 FETCH FULL PROFILE
                    AuthService.shared.fetchProfile(userId: id) { result in
                        DispatchQueue.main.async {
                            isLoading = false

                            if case .success(let user) = result {
                                currentUserName = user.name
                                currentUserEmail = user.email
                                currentUserPhone = user.phone ?? ""
                                currentUserBio = user.bio ?? ""
                                currentUserProfileImage = user.profile_image ?? ""
                                isLoggedIn = true
                            } else {
                                errorMessage = "Failed to load profile"
                            }
                        }
                    }

                case .failure:
                    isLoading = false
                    errorMessage = "Server error. Try again."
                }
            }
        }
    }

    // MARK: - Reusable Input Field
    func inputField(
        icon: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool
    ) -> some View {

        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 22)

            if isSecure {
                SecureField(placeholder, text: text)
            } else {
                TextField(placeholder, text: text)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
            }
        }
        .padding()
        .background(Color(.tertiarySystemFill))
        .cornerRadius(16)
    }
}
