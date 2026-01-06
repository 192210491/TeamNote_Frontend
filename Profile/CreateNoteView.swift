import SwiftUI

struct CreateNoteView: View {

    @Environment(\.dismiss) private var dismiss
    @AppStorage("userId") private var userId: Int = 0

    @State private var title = ""
    @State private var content = ""
    @State private var isSaving = false
    @State private var errorMessage = ""

    var body: some View {
        Form {

            Section {
                TextField("Title", text: $title)
                    .font(.headline)
            }

            Section {
                TextEditor(text: $content)
                    .frame(minHeight: 200)
            }

            if !errorMessage.isEmpty {
                Section {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
        }
        .navigationTitle("New Note")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {

            // Cancel
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }

            // Save
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    saveNote()
                } label: {
                    if isSaving {
                        ProgressView()
                    } else {
                        Text("Save")
                            .bold()
                    }
                }
                .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || isSaving)
            }
        }
    }

    // MARK: - SAVE NOTE
    private func saveNote() {

        guard userId > 0 else {
            errorMessage = "User not logged in"
            return
        }

        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Title required"
            return
        }

        isSaving = true
        errorMessage = ""

        NotesService.shared.createNote(
            userId: userId,
            title: title,
            content: content
        ) { result in
            isSaving = false

            if case .success(let ok) = result, ok {
                dismiss()   // ✅ NotesView auto-refresh already works
            } else {
                errorMessage = "Failed to save note"
            }
        }
    }
}

