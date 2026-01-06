import SwiftUI

struct ProfileView: View {

    // MARK: - Auth
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = true
    @AppStorage("userId") private var userId: Int = 0

    // ✅ SINGLE SOURCE OF TRUTH
    @AppStorage("currentUserName") private var userName: String = ""
    @AppStorage("currentUserEmail") private var userEmail: String = ""
    @AppStorage("currentUserBio") private var userBio: String = ""
    @AppStorage("currentUserPhone") private var userPhone: String = ""
    @AppStorage("currentUserProfileImage") private var profileImageName: String = ""

    @State private var showLogoutAlert = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {

                    // MARK: - AVATAR
                    VStack(spacing: 10) {
                        if let url = profileImageURL {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Circle().fill(Color.gray.opacity(0.3))
                            }
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                        } else {
                            fallbackAvatar
                        }

                        Text(userName.isEmpty ? "Unknown User" : userName)
                            .font(.title2)
                            .fontWeight(.semibold)

                        Text(userEmail)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 10)

                    // MARK: - STATS (STATIC)
                    HStack(spacing: 16) {
                        StatCard(icon: "rosette", title: "Score", value: "92", color: .blue)
                        StatCard(icon: "target", title: "Updates", value: "156", color: .green)
                        StatCard(icon: "bolt.fill", title: "Streak", value: "12", color: .purple)
                    }

                    // MARK: - OPTIONS
                    VStack(spacing: 14) {
                        NavigationLink {
                            NotificationsView()
                        } label: {
                            ProfileRow(icon: "bell.fill", title: "Notifications", badge: "2")
                        }

                        NavigationLink {
                            SettingsView()
                        } label: {
                            ProfileRow(icon: "gearshape.fill", title: "Settings")
                        }

                        NavigationLink {
                            PrivacySecurityView()
                        } label: {
                            ProfileRow(icon: "shield.fill", title: "Privacy & Security")
                        }

                        NavigationLink {
                            EditProfileView()
                        } label: {
                            ProfileRow(icon: "person.fill", title: "Edit Profile")
                        }
                    }

                    // MARK: - LOGOUT
                    Button {
                        showLogoutAlert = true
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: "arrow.right.square")
                            Text("Logout").fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.red, .pink],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(18)
                    }
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Logout", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Logout", role: .destructive) {
                    logout()
                }
            } message: {
                Text("Are you sure you want to logout?")
            }
        }
    }

    // MARK: - FALLBACK AVATAR
    private var fallbackAvatar: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [.blue, .purple, .pink],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 120, height: 120)
            .overlay(
                Text(
                    userName.isEmpty
                    ? "?"
                    : String(userName.prefix(1)).uppercased()
                )
                .font(.system(size: 44, weight: .bold))
                .foregroundColor(.white)
            )
    }

    // MARK: - IMAGE URL
    private var profileImageURL: URL? {
        guard !profileImageName.isEmpty else { return nil }
        return URL(
            string: "http://localhost/teamnote_api/uploads/profile/\(profileImageName)"
        )
    }

    // MARK: - LOGOUT (🔥 COMPLETE RESET)
    private func logout() {
        isLoggedIn = false
        userId = 0
        userName = ""
        userEmail = ""
        userBio = ""
        userPhone = ""
        profileImageName = ""
    }
}
