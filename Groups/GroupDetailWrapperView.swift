import SwiftUI

struct GroupDetailWrapperView: View {

    @EnvironmentObject var groupStore: GroupStore
    let groupID: Int

    var body: some View {
        GroupDetailView(groupID: groupID)
    }
}

