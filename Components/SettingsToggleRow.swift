import SwiftUI

struct SettingsToggleRow: View {
    let title: String
    @Binding var isOn: Bool
    let icon: String

    var body: some View {
        HStack(spacing: 14) {

            // MARK: - Icon
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.blue)
                .frame(width: 36, height: 36)
                .background(
                    Color.blue.opacity(0.15)
                )
                .cornerRadius(10)

            // MARK: - Title
            Text(title)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()

            // MARK: - Toggle
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding()
        .background(
            Color(.secondarySystemGroupedBackground) // ✅ dark-mode safe
        )
        .cornerRadius(18)
        .shadow(
            color: Color.black.opacity(0.25),
            radius: 8,
            x: 0,
            y: 4
        )
        .padding(.horizontal)
    }
}

