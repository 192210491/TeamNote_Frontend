import SwiftUI

struct EmptyNotesView: View {
    var body: some View {
        VStack(spacing: 16) {

            Image(systemName: "note.text")
                .font(.system(size: 48))
                .foregroundColor(.gray)

            Text("No Notes Yet")
                .font(.headline)

            Text("Tap + to create your first note")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}

#Preview {
    EmptyNotesView()
}

