import SwiftUI

struct AuthEntryView: View {

    // 🔗 Navigation state for auth flow
    @State private var path: [AuthRoute] = [.login]

    var body: some View {
        NavigationStack(path: $path) {
            LoginView(path: $path)
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {

                    case .login:
                        LoginView(path: $path)

                    case .signup:
                        SignupView(path: $path)

                    case .forgotPassword:
                        ForgotPasswordView(path: $path)

                    case .otp(let email):
                        OTPView(email: email, path: $path)   // ✅ FIX

                    case .reset(let email):
                        ResetPasswordView(email: email, path: $path) // ✅ FIX

                    case .main:
                        MainTabView()
                    }
                }
        }
    }
}

