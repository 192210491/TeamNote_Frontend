import SwiftUI

struct GroupCard: View {

    let name: String
    let members: Int
    let description: String
    let lastUpdate: String
    let isActive: Bool

    var body: some View {
        HStack(spacing: 16) {

            // Left icon
            ZStack {
                LinearGradient(
                    colors: [Color.blue, Color.purple],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Image(systemName: "person.2.fill")
                    .foregroundColor(.white)
            }
            .frame(width: 52, height: 52)
            .cornerRadius(18)

            // Center content
            VStack(alignment: .leading, spacing: 6) {
                Text(name)
                    .font(.headline)

                Text("\(members) members")
                    .foregroundColor(.gray)
                    .font(.subheadline)

                Text(description)
                    .foregroundColor(.gray)
                    .font(.subheadline)

                Text("Last: \(lastUpdate)")
                    .foregroundColor(.gray)
                    .font(.caption)
            }

            Spacer()

            // Right side
            VStack(spacing: 8) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)

                if isActive {
                    Text("Active")
                        .font(.caption)
                        .foregroundColor(.green)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.15))
                        .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.06), radius: 10)
    }
}


