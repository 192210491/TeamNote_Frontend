import SwiftUI

struct ActivityQuickCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let colors: [Color]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .padding(10)
                .background(Color.white.opacity(0.2))
                .clipShape(Circle())

            Text(title)
                .fontWeight(.semibold)
                .foregroundColor(.white)

            Text(subtitle)
                .font(.footnote)
                .foregroundColor(.white.opacity(0.9))
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 120)
        .background(
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
    }
}

