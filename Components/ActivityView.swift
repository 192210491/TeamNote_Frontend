import SwiftUI

struct ActivityView: View {

    @EnvironmentObject var activityStore: ActivityStore
    @EnvironmentObject var groupStore: GroupStore

    @AppStorage("currentUserName") private var currentUserName: String = "Bunny"

    @State private var showAddUpdate = false
    @State private var showTimeline = false
    @State private var showHeatmap = false

    @State private var showGroupPicker = false
    @State private var selectedGroupId: Int?
    @State private var selectedUpdate: ActivityUpdate?

    var body: some View {
        NavigationStack {

            List {

                // FEATURE CARDS
                Section {
                    HStack(spacing: 16) {

                        Button { showTimeline = true } label: {
                            ActivityFeatureCard(
                                title: "Timeline",
                                subtitle1: "Replay",
                                subtitle2: "Watch progress",
                                colors: [.pink, .purple],
                                icon: "play.fill"
                            )
                        }
                        .buttonStyle(.plain)

                        Button { showHeatmap = true } label: {
                            ActivityFeatureCard(
                                title: "Activity",
                                subtitle1: "Heatmap",
                                subtitle2: "View by person",
                                colors: [.green, .mint],
                                icon: "calendar"
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(.init())

                // UPDATES
                Section("Recent Updates") {

                    ForEach(activityStore.updates) { update in

                        ActivityUpdateCard(update: update)
                            .frame(maxWidth: .infinity)      // 🔑 critical
                            .listRowInsets(
                                EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                            )
                            .listRowSeparator(.hidden)

                            // DELETE
                            .swipeActions(edge: .trailing) {
                                if update.name == currentUserName {
                                    Button(role: .destructive) {
                                        activityStore.deleteUpdate(update)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }

                            // EDIT
                            .swipeActions(edge: .leading) {
                                if update.name == currentUserName {
                                    Button {
                                        selectedUpdate = update
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                    .tint(.blue)
                                }
                            }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Activity")

            // ➕ FLOATING BUTTON (SAFE)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    showGroupPicker = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title2)
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
                .padding()
            }

            // NAVIGATION
            .navigationDestination(isPresented: $showTimeline) {
                ActivityTimelineView()
                    .environmentObject(activityStore)
            }

            .navigationDestination(isPresented: $showHeatmap) {
                ActivityHeatmapView()
                    .environmentObject(activityStore)
                    .environmentObject(groupStore)
            }

            .sheet(isPresented: $showGroupPicker) {
                NavigationStack {
                    List(groupStore.groups) { group in
                        Button {
                            selectedGroupId = group.id
                            showGroupPicker = false
                            showAddUpdate = true
                        } label: {
                            HStack {
                                Text(group.name)
                                Spacer()
                                Image(systemName: "chevron.right")
                            }
                        }
                    }
                    .navigationTitle("Select Group")
                }
            }

            .sheet(isPresented: $showAddUpdate) {
                if let groupId = selectedGroupId {
                    AddUpdateView(selectedGroupId: groupId)
                        .environmentObject(groupStore)
                        .environmentObject(activityStore)
                }
            }

            .sheet(item: $selectedUpdate) { update in
                EditUpdateView(update: update)
                    .environmentObject(activityStore)
            }
        }
    }
}
