import SwiftUI

struct EditUpdateView: View {

    // ✅ Environment
    @EnvironmentObject private var activityStore: ActivityStore
    @Environment(\.dismiss) private var dismiss

    let update: ActivityUpdate

    @State private var message: String
    @State private var status: TaskStatus

    init(update: ActivityUpdate) {
        self.update = update
        _message = State(initialValue: update.message)
        _status = State(initialValue: update.status)
    }

    var body: some View {
        NavigationStack {
            Form {

                Section(header: Text("Update")) {
                    TextEditor(text: $message)
                        .frame(height: 120)
                }

                Section(header: Text("Status")) {
                    Picker("Status", selection: $status) {
                        ForEach(TaskStatus.allCases, id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                }
            }
            .navigationTitle("Edit Update")
            .toolbar {

                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        save()
                    }
                    .bold()
                    .disabled(
                        message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    )
                }
            }
        }
    }

    // MARK: - SAVE (✅ MODEL-SAFE)
    private func save() {

        let updated = ActivityUpdate(
            id: update.id,                  // ✅ same ID
            name: update.name,
            groupId: update.groupId,
            memberId: update.memberId,
            createdAt: update.createdAt,
            contentType: update.contentType,
            message: message,
            status: status,
            time: "Edited just now"
        )

        // ✅ Local UI update
        activityStore.updateExisting(updated)

        // ✅ Backend sync (owner-locked in PHP)
        activityStore.syncEditUpdate(updated)

        dismiss()
    }
}
