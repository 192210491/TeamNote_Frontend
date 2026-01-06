import SwiftUI

struct StatCard: View {

    let icon: String
    let title: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 10) {

            // MARK: - Icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
            }

            // MARK: - Value
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.white)

            // MARK: - Title
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            LinearGradient(
                colors: [
                    color,
                    color.opacity(0.85)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(
            color: Color.black.opacity(0.35),
            radius: 10,
            x: 0,
            y: 6
        )
    }
}

