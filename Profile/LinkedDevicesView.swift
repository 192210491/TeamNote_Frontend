import SwiftUI

struct LinkedDevicesView: View {

    @Environment(\.dismiss) private var dismiss

    // Dummy linked devices (backend will replace this later)
    @State private var devices: [LinkedDevice] = [
        LinkedDevice(
            name: "iPhone 14 Pro",
            platform: "iOS",
            lastActive: "Active now",
            isCurrent: true
        ),
        LinkedDevice(
            name: "MacBook Pro",
            platform: "macOS",
            lastActive: "2 hours ago",
            isCurrent: false
        ),
        LinkedDevice(
            name: "iPad Air",
            platform: "iPadOS",
            lastActive: "Yesterday",
            isCurrent: false
        )
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // MARK: - Header
                VStack(spacing: 6) {
                    Text("Linked Devices")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("Devices currently logged into your account")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)

                // MARK: - Devices List
                VStack(spacing: 14) {
                    ForEach(devices) { device in
                        deviceRow(device)
                    }
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Linked Devices")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Device Row
    private func deviceRow(_ device: LinkedDevice) -> some View {
        HStack(spacing: 14) {

            Image(systemName: deviceIcon(device.platform))
                .font(.title2)
                .foregroundColor(device.isCurrent ? .blue : .gray)
                .frame(width: 36)

            VStack(alignment: .leading, spacing: 4) {
                Text(device.name)
                    .font(.headline)

                Text(device.lastActive)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if device.isCurrent {
                Text("This device")
                    .font(.caption)
                    .foregroundColor(.green)
            } else {
                Button {
                    removeDevice(device)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                        .font(.title3)
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(18)
    }

    // MARK: - Helpers
    private func deviceIcon(_ platform: String) -> String {
        switch platform {
        case "iOS": return "iphone"
        case "macOS": return "laptopcomputer"
        case "iPadOS": return "ipad"
        default: return "questionmark"
        }
    }

    private func removeDevice(_ device: LinkedDevice) {
        // FRONTEND ONLY (backend later)
        devices.removeAll { $0.id == device.id }
    }
}

// MARK: - Model
struct LinkedDevice: Identifiable {
    let id = UUID()
    let name: String
    let platform: String
    let lastActive: String
    let isCurrent: Bool
}

