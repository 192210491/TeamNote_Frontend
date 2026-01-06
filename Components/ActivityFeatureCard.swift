import SwiftUI

struct ActivityFeatureCard: View {
    let title: String
    let subtitle1: String
    let subtitle2: String
    let colors: [Color]
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)

            Text(title)
                .font(.headline)
                .foregroundColor(.white)

            Text(subtitle1)
                .foregroundColor(.white.opacity(0.9))

            Text(subtitle2)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 130, alignment: .leading)
        .background(
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(20)
    }
}

