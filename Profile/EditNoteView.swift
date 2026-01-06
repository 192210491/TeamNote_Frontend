import SwiftUI

struct EditNoteView: View {

    @Environment(\.dismiss) private var dismiss
    let note: Note

    @State private var title: String
    @State private var content: String
    @State private var isSaving = false
    @State private var errorMessage = ""

    init(note: Note) {
        self.note = note
        _title = State(initialValue: note.title)
        _content = State(initialValue: note.content)
    }

    var body: some View {
        VStack(spacing: 16) {

            TextField("Title", text: $title)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)

            TextEditor(text: $content)
                .frame(height: 200)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Button("Update Note") {
                updateNote()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white)
            .cornerRadius(20)
        }
        .padding()
        .navigationTitle("Edit Note")
    }

    private func updateNote() {

        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Title required"
            return
        }

        isSaving = true
        errorMessage = ""

        NotesService.shared.updateNote(
            noteId: note.id,   // ✅ FIXED LINE
            title: title,
            content: content
        ) { success in
            isSaving = false
            success ? dismiss() : (errorMessage = "Update failed")
        }
    }
}

