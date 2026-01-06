enum AuthRoute: Hashable {
    case login
    case signup
    case forgotPassword
    case otp(email: String)
    case reset(email: String)
    case main
}
