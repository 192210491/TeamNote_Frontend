import SwiftUI

struct MainTabView: View {

    // ✅ USE shared instances from App root
    @EnvironmentObject var groupStore: GroupStore
    @EnvironmentObject var activityStore: ActivityStore

    var body: some View {
        TabView {

            // 🏠 Home
            HomeView()
                .environmentObject(groupStore)
                .environmentObject(activityStore)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            // 📝 Notes
            NotesView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }

            // 👥 Groups
            GroupsView()
                .environmentObject(groupStore)
                .environmentObject(activityStore)
                .tabItem {
                    Label("Groups", systemImage: "person.3")
                }

            // 📊 Activity
            ActivityView()
                .environmentObject(activityStore)
                .environmentObject(groupStore)
                .tabItem {
                    Label("Activity", systemImage: "waveform")
                }

            // 👤 Profile
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        // 🔥 AUTO REFRESH when selected group changes
        .onChange(of: groupStore.selectedGroupId) { newGroupId in
            guard let groupId = newGroupId else { return }
            activityStore.fetchTimeline(groupId: groupId)
        }
    }
}

