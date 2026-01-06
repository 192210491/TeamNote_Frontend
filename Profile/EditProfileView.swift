import SwiftUI

struct EditProfileView: View {

    @Environment(\.dismiss) private var dismiss

    // 🔑 USER ID
    @AppStorage("userId") private var userId: Int = 0

    // ✅ SINGLE SOURCE OF TRUTH
    @AppStorage("currentUserName") private var storedName: String = ""
    @AppStorage("currentUserEmail") private var storedEmail: String = ""
    @AppStorage("currentUserPhone") private var storedPhone: String = ""
    @AppStorage("currentUserBio") private var storedBio: String = ""
    @AppStorage("currentUserProfileImage") private var profileImageName: String = ""

    // Editable copies
    @State private var fullName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var bio = ""

    // 🖼️ IMAGE
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false
    @State private var isSaving = false

    private var profileImageURL: URL? {
        guard !profileImageName.isEmpty else { return nil }
        return URL(string: "http://localhost/teamnote_api/uploads/profile/\(profileImageName)")
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {

                    // MARK: - Avatar
                    VStack(spacing: 12) {
                        ZStack(alignment: .bottomTrailing) {

                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipShape(Circle())

                            } else if let url = profileImageURL {
                                AsyncImage(url: url) { img in
                                    img.resizable().scaledToFill()
                                } placeholder: {
                                    Circle().fill(Color.gray.opacity(0.3))
                                }
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())

                            } else {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [.blue, .purple, .pink],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 120, height: 120)
                                    .overlay(
                                        Text(
                                            fullName.isEmpty
                                            ? "?"
                                            : String(fullName.prefix(1)).uppercased()
                                        )
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    )
                            }

                            Button {
                                showImagePicker = true
                            } label: {
                                Image(systemName: "camera.fill")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(
                                        LinearGradient(colors: [.blue, .purple],
                                                       startPoint: .topLeading,
                                                       endPoint: .bottomTrailing)
                                    )
                                    .clipShape(Circle())
                            }
                        }

                        Text("Tap to change photo")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }

                    // MARK: - Fields
                    VStack(spacing: 18) {
                        inputField(title: "Full Name", text: $fullName)
                        inputField(title: "Email", text: $email, icon: "envelope.fill", keyboard: .emailAddress)
                        inputField(title: "Phone", text: $phone, icon: "phone.fill", keyboard: .phonePad)
                        bioField(title: "Bio", text: $bio)
                    }
                }
                .padding()
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isSaving ? "Saving..." : "Save") {
                        uploadProfile()
                    }
                    .disabled(isSaving)
                }
            }
            .onAppear(perform: loadProfile)
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $selectedImage)
            }
        }
    }

    // MARK: - LOAD
    private func loadProfile() {
        fullName = storedName
        email = storedEmail
        phone = storedPhone
        bio = storedBio
    }

    // MARK: - UPLOAD
    private func uploadProfile() {

        guard userId > 0 else { return }
        isSaving = true

        let boundary = UUID().uuidString
        let url = URL(string: "http://localhost/teamnote_api/profile/update.php")!


        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        func add(_ name: String, _ value: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        add("user_id", "\(userId)")
        add("name", fullName)
        add("phone", phone)
        add("bio", bio)

        if let image = selectedImage,
           let data = image.jpegData(compressionQuality: 0.8) {

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"profile.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(data)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.main.async {

                self.isSaving = false

                guard let data = data,
                      let decoded = try? JSONDecoder().decode(ProfileUpdateResponse.self, from: data),
                      decoded.success else {
                    self.dismiss()
                    return
                }

                self.storedName = self.fullName
                self.storedPhone = self.phone
                self.storedBio = self.bio

                if let img = decoded.image {
                    self.profileImageName = img
                }

                self.dismiss()
            }
        }.resume()
    }

    // MARK: - Reusable Inputs (MOVED INSIDE STRUCT)

    private func inputField(
        title: String,
        text: Binding<String>,
        icon: String? = nil,
        keyboard: UIKeyboardType = .default
    ) -> some View {

        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.footnote)
                .foregroundColor(.secondary)

            HStack(spacing: 10) {
                if let icon {
                    Image(systemName: icon)
                        .foregroundColor(.secondary)
                }

                TextField(title, text: text)
                    .keyboardType(keyboard)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(16)
        }
    }

    private func bioField(
        title: String,
        text: Binding<String>
    ) -> some View {

        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.footnote)
                .foregroundColor(.secondary)

            TextEditor(text: text)
                .frame(height: 120)
                .padding(12)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(16)
        }
    }
}
