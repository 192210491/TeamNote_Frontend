import SwiftUI

struct NotesView: View {

    // MARK: - State
    @State private var notes: [Note] = []
    @State private var isLoading = true

    @State private var showCreate = false

    // EDIT + DELETE
    @State private var selectedNote: Note?
    @State private var noteToDelete: Note?
    @State private var showDeleteAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                // LOADING
                if isLoading {
                    ProgressView("Loading notes...")
                }

                // EMPTY STATE
                else if notes.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "note.text")
                            .font(.system(size: 44))
                            .foregroundColor(.gray)

                        Text("No notes yet")
                            .font(.headline)
                            .foregroundColor(.gray)

                        Text("Tap + to create your first note")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                // NOTES LIST
                else {
                    List {
                        ForEach(notes) { note in
                            NoteCard(note: note)
                                .listRowSeparator(.hidden)

                                // DELETE (RIGHT)
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        noteToDelete = note
                                        showDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }

                                // EDIT (LEFT)
                                .swipeActions(edge: .leading) {
                                    Button {
                                        selectedNote = note
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                        }
                    }
                    .listStyle(.plain)
                }

                // FLOATING ADD BUTTON
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            showCreate = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .clipShape(Circle())
                                .shadow(radius: 6)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }

                // 🔒 HIDDEN EDIT NAVIGATION (iOS 16 SAFE)
                NavigationLink(
                    isActive: Binding(
                        get: { selectedNote != nil },
                        set: { if !$0 { selectedNote = nil } }
                    )
                ) {
                    if let note = selectedNote {
                        EditNoteView(note: note)
                            .onDisappear {
                                fetchNotes()
                            }
                    } else {
                        EmptyView()
                    }
                } label: {
                    EmptyView()
                }
                .hidden()
            }
            .navigationTitle("Notes")

            // CREATE NOTE
            .navigationDestination(isPresented: $showCreate) {
                CreateNoteView()
                    .onDisappear {
                        fetchNotes()
                    }
            }

            // DELETE CONFIRMATION
            .alert(
                "Delete Note?",
                isPresented: $showDeleteAlert,
                presenting: noteToDelete
            ) { note in
                Button("Delete", role: .destructive) {
                    performDelete(note)
                }
                Button("Cancel", role: .cancel) {}
            } message: { _ in
                Text("This action cannot be undone.")
            }
        }
        .onAppear {
            fetchNotes()
        }
    }

    // MARK: - FETCH
    private func fetchNotes() {
        let userId = UserDefaults.standard.integer(forKey: "userId")
        guard userId > 0 else {
            isLoading = false
            return
        }

        isLoading = true

        NotesService.shared.fetchNotes(userId: userId) { result in
            isLoading = false
            if case .success(let fetched) = result {
                notes = fetched
            }
        }
    }

    // MARK: - DELETE
    private func performDelete(_ note: Note) {
        NotesService.shared.deleteNote(noteId: note.id) { success in
            if success {
                notes.removeAll { $0.id == note.id }
            }
        }
    }
}

