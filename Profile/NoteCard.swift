import SwiftUI

struct NoteCard: View {

    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // TITLE
            Text(note.title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(1)

            // CONTENT (optional)
            if !note.content.isEmpty {
                Text(note.content)
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 4)

            // DATE
            HStack {
                Spacer()
                Text(note.createdAt)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 90, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.black.opacity(0.04))
        )
    }
}

