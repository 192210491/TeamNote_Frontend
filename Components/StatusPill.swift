import SwiftUI

struct StatusPill: View {

    let title: String
    let selected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .foregroundColor(selected ? .white : .primary)
                .background(
                    Capsule()
                        .fill(selected ? color : Color(.systemGray5))
                )
        }
    }
}

