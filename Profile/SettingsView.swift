import SwiftUI

struct SettingsView: View {

    @State private var notificationsEnabled = true

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                // MARK: - App Preferences
                VStack(alignment: .leading, spacing: 12) {
                    Text("App Preferences")
                        .font(.headline)
                        .padding(.horizontal)

                    SettingsToggleRow(
                        title: "Notifications",
                        isOn: $notificationsEnabled,
                        icon: "bell.fill"
                    )
                }

                // MARK: - Account
                VStack(alignment: .leading, spacing: 12) {
                    Text("Account")
                        .font(.headline)
                        .padding(.horizontal)

                    NavigationLink {
                        ChangePasswordView()
                    } label: {
                        SettingsNavRow(
                            title: "Change Password",
                            icon: "lock.fill"
                        )
                    }

                    NavigationLink {
                        LinkedDevicesView()
                    } label: {
                        NavigationLink {
                            LinkedDevicesView()
                        } label: {
                            SettingsNavRow(
                                title: "Linked Devices",
                                icon: "laptopcomputer"
                            )
                        }

                    }
                }

                // MARK: - About
                VStack(alignment: .leading, spacing: 12) {
                    Text("About")
                        .font(.headline)
                        .padding(.horizontal)

                    NavigationLink {
                        TermsConditionsView()
                    } label: {
                        NavigationLink {
                            TermsConditionsView()
                        } label: {
                            SettingsNavRow(
                                title: "Terms & Conditions",
                                icon: "doc.text.fill"
                            )
                        }

                    }

                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        NavigationLink {
                            PrivacyPolicyView()
                        } label: {
                            SettingsNavRow(
                                title: "Privacy Policy",
                                icon: "hand.raised.fill"
                            )
                        }

                    }

                    // App Version (NON-TAPPABLE)
                    SettingsNavRow(
                        title: "App Version",
                        icon: "info.circle.fill",
                        trailingText: "1.0.0"
                    )
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

