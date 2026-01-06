import SwiftUI

enum UpdateMode {
    case text
    case image
    case voice
}

struct AddUpdateView: View {
 
    @StateObject private var voiceRecorder = VoiceRecorder()
    @Environment(\.dismiss) private var dismiss

    // 🔗 STORES (SINGLE SOURCE OF TRUTH)
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var activityStore: ActivityStore

    // USER
    @AppStorage("userId") private var userId: Int = 0

    // MARK: - State
    @State private var mode: UpdateMode = .text
    @State private var message = ""
    @State private var status: TaskStatus = .todo

    // Image picker
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    let selectedGroupId: Int
    var body: some View {
        ZStack(alignment: .bottom) {

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // MARK: - Header
                    HStack {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.headline)
                        }

                        Spacer()

                        Text("Add Update")
                            .font(.title3)
                            .bold()

                        Spacer()
                    }

                    // MARK: - Mode Selector
                    HStack(spacing: 14) {
                        modeButton(.text, "Text", "doc.text")
                        modeButton(.image, "Image", "photo")
                        modeButton(.voice, "Voice", "mic")
                    }

                    // MARK: - Mode Content
                    modeContent

                    // MARK: - Task Status
                    Text("Task Status")
                        .font(.headline)

                    HStack(spacing: 12) {
                        statusButton(.todo)
                        statusButton(.inProgress)
                        statusButton(.completed)
                    }

                    Spacer(minLength: 160)
                }
                .padding()
            }

            // MARK: - Post Button
            Button(action: postUpdate) {
                Text("Post Update")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(18)
                    .padding()
            }
            .disabled(mode == .text && message.isEmpty)
            .opacity(mode == .text && message.isEmpty ? 0.45 : 1)
        }
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }

    // MARK: - POST (GROUP SAFE + SYNCED)
    private func postUpdate() {

        let contentType: UpdateContentType
        let finalMessage: String

        switch mode {
        case .text:
            contentType = .text
            finalMessage = message

        case .image:
            contentType = .image
            finalMessage = message.isEmpty ? "Image update" : message

        case .voice:
            contentType = .voice
            finalMessage = voiceRecorder.transcript.isEmpty
                ? "Voice update"
                : voiceRecorder.transcript
        }

        activityStore.createUpdate(
            groupId: selectedGroupId,
            contentType: contentType,
            message: finalMessage
        ) { success in
            if success {
                activityStore.fetchTimeline(groupId: selectedGroupId)
            } else {
                print("❌ Failed to post update")
            }
        }

        dismiss()
    }


    // MARK: - UI HELPERS (UNCHANGED)

    private func modeButton(
        _ value: UpdateMode,
        _ title: String,
        _ icon: String
    ) -> some View {

        Button { mode = value } label: {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)

                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        mode == value
                        ? Color.blue.opacity(0.18)
                        : Color(.secondarySystemGroupedBackground)
                    )
            )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var modeContent: some View {
        switch mode {
        case .text: textView
        case .image: imageView
        case .voice: voiceView
        }
    }

    private var textView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("What did you work on?")
                .font(.headline)

            TextEditor(text: $message)
                .frame(height: 130)
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(16)
        }
    }

    private var imageView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Upload Image")
                .font(.headline)

            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .clipped()
                    .cornerRadius(20)
            } else {
                Button {
                    showImagePicker = true
                } label: {
                    Text("Tap to select image")
                }
            }
        }
    }

    private var voiceView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Record Voice Note")
                .font(.headline)

            Button {
                voiceRecorder.isRecording
                ? voiceRecorder.stopRecording()
                : try? voiceRecorder.startRecording()

                if !voiceRecorder.isRecording {
                    message = voiceRecorder.transcript
                }
            } label: {
                Image(systemName: "mic.circle.fill")
                    .font(.system(size: 64))
                    .foregroundColor(.red)
            }
        }
    }

    private func statusButton(_ value: TaskStatus) -> some View {
        Button {
            status = value
        } label: {
            Text(value.rawValue)
                .font(.subheadline)
                .foregroundColor(status == value ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    status == value
                    ? value.color
                    : Color(.secondarySystemGroupedBackground)
                )
                .cornerRadius(14)
        }
    }
}
