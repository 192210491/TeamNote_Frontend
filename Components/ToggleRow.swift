import SwiftUI

struct ToggleRow: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(title)
                .font(.body)
                .foregroundColor(.primary)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding()
        .background(
            Color(.secondarySystemGroupedBackground) // ✅ dark-mode safe
        )
        .cornerRadius(18)
        .shadow(
            color: Color.black.opacity(0.25), // consistent with other cards
            radius: 8,
            x: 0,
            y: 4
        )
        .padding(.horizontal)
    }
}

