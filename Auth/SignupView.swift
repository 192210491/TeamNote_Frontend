import SwiftUI

struct SignupView: View {

    @Binding var path: [AuthRoute]

    @AppStorage("isLoggedIn") private var isLoggedIn = false
    @AppStorage("userId") private var userId: Int = 0
    @AppStorage("currentUserName") private var currentUserName: String = ""
    @AppStorage("currentUserEmail") private var currentUserEmail: String = ""
    @AppStorage("currentUserPhone") private var currentUserPhone: String = ""

    @State private var fullName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var password = ""
    @State private var confirmPassword = ""

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
                        Text("Create Account")
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text("Join TeamNote today")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    inputField(icon: "person.fill", placeholder: "Full Name", text: $fullName)
                    inputField(icon: "envelope.fill", placeholder: "Email", text: $email)
                    inputField(icon: "phone.fill", placeholder: "Phone Number", text: $phone)
                    inputField(icon: "lock.fill", placeholder: "Password", text: $password, isSecure: true)
                    inputField(icon: "lock.fill", placeholder: "Confirm Password", text: $confirmPassword, isSecure: true)

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                    }

                    Button {
                        register()
                    } label: {
                        if isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("Create Account")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        LinearGradient(
                            colors: [.blue, .purple, .pink],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(20)
                    .disabled(isLoading)

                    HStack(spacing: 6) {
                        Text("Already have an account?")
                            .font(.footnote)
                            .foregroundColor(.secondary)

                        Button("Login") {
                            path = [.login]
                        }
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    }
                }
                .padding(28)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(30)
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }

    // MARK: - REGISTER → AUTO LOGIN
    private func register() {
        
        errorMessage = ""
        
        guard !fullName.isEmpty,
              !email.isEmpty,
              !phone.isEmpty,
              !password.isEmpty else {
            errorMessage = "All fields are required"
            return
        }
        
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }
        
        isLoading = true
        
        AuthService.shared.register(
            name: fullName,
            email: email,
            phone: phone,
            password: password
        ) { result in
            switch result {
            case .success(let response):
                if response.success {
                    autoLogin()
                } else {
                    isLoading = false
                    errorMessage = response.message ?? "Registration failed"
                }
                
            case .failure:
                isLoading = false
                errorMessage = "Server error"
            }
        }
    }

    // MARK: - AUTO LOGIN
    private func autoLogin() {
        AuthService.shared.login(email: email, password: password) { result in
            isLoading = false

            switch result {
            case .success(let response):
                guard response.success,
                      let uid = response.user_id,
                      let name = response.name
                else {
                    errorMessage = "Login failed"
                    return
                }

                userId = uid
                currentUserName = name
                currentUserEmail = email
                currentUserPhone = phone
                isLoggedIn = true

            case .failure:
                errorMessage = "Login failed"
            }
        }
    }

    // MARK: - Input Field (UNCHANGED)
    private func inputField(
        icon: String,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false
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
            }
        }
        .padding()
        .background(Color(.tertiarySystemFill))
        .cornerRadius(16)
    }
}
