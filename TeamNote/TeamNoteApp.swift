import SwiftUI

@main
struct TeamNoteApp: App {

    @StateObject private var activityStore = ActivityStore()
    @StateObject private var groupStore = GroupStore()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(activityStore)
                .environmentObject(groupStore)
        }
    }
}

