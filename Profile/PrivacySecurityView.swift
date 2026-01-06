import SwiftUI

struct PrivacySecurityView: View {

    // MARK: - Privacy States
    @State private var isPublicProfile = true
    @State private var showActivityStatus = true
    @State private var allowDataSharing = true

    // MARK: - 2FA (Persisted)
    @AppStorage("is2FAEnabled") private var is2FAEnabled: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // MARK: - Profile Visibility
                VStack(alignment: .leading, spacing: 12) {
                    Text("Profile Visibility")
                        .font(.headline)
                        .padding(.horizontal)

                    HStack {

                        // MARK: Public
                        // MARK: Public
                        Button {
                            isPublicProfile = true
                        } label: {
                            Text("Public")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(isPublicProfile ? .white : .primary)
                                .background {
                                    if isPublicProfile {
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    } else {
                                        Color(.secondarySystemGroupedBackground)
                                    }
                                }
                                .cornerRadius(14)
                        }


                        // MARK: Private
                        Button {
                            isPublicProfile = false
                        } label: {
                            Text("Private")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(!isPublicProfile ? .white : .primary)
                                .background {
                                    if !isPublicProfile {
                                        LinearGradient(
                                            colors: [.blue, .purple],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    } else {
                                        Color(.secondarySystemGroupedBackground)
                                    }
                                }
                                .cornerRadius(14)
                        }

                    }
                    .padding(.horizontal)
                }

                // MARK: - Privacy Options
                VStack(alignment: .leading, spacing: 12) {
                    Text("Privacy Options")
                        .font(.headline)
                        .padding(.horizontal)

                    SettingsToggleRow(
                        title: "Show Activity Status",
                        isOn: $showActivityStatus,
                        icon: "eye.fill"
                    )

                    SettingsToggleRow(
                        title: "Allow Data Sharing",
                        isOn: $allowDataSharing,
                        icon: "hand.raised.fill"
                    )
                }

                // MARK: - Security
                VStack(alignment: .leading, spacing: 12) {
                    Text("Security")
                        .font(.headline)
                        .padding(.horizontal)

                    NavigationLink {
                        Enable2FAView()
                    } label: {
                        SettingsNavRow(
                            title: "Two-Factor Authentication",
                            icon: "lock.shield.fill",
                            trailingText: is2FAEnabled ? "Enabled" : "Off"
                        )
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Privacy & Security")
        .navigationBarTitleDisplayMode(.inline)
    }
}

