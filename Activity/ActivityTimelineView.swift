import SwiftUI

struct ActivityTimelineView: View {

    @EnvironmentObject var activityStore: ActivityStore
    @EnvironmentObject var groupStore: GroupStore
    @Environment(\.dismiss) private var dismiss

    @State private var currentIndex = 0

    private var items: [ActivityTimelineItem] {
        guard let groupId = groupStore.selectedGroupId else { return [] }

        return activityStore.updates
            .filter { $0.groupId == groupId }
            .map {
                ActivityTimelineItem(
                    name: $0.name,
                    initial: String($0.name.prefix(1)),
                    message: $0.message,
                    status: $0.status,
                    time: $0.time
                )
            }
    }

    var body: some View {
        ZStack {

            LinearGradient(
                colors: [
                    Color.black,
                    Color.black.opacity(0.85),
                    Color.black.opacity(0.75)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {

                HStack {
                    Spacer()
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.15))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)

                Spacer()

                if items.isEmpty {
                    Text("No updates yet")
                        .foregroundColor(.white.opacity(0.6))
                        .padding()
                } else {
                    TabView(selection: $currentIndex) {
                        ForEach(items.indices, id: \.self) { index in
                            TimelineCard(
                                item: items[index],
                                index: index,
                                total: items.count
                            )
                            .padding(.horizontal)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 420)

                    HStack(spacing: 8) {
                        ForEach(items.indices, id: \.self) { index in
                            Circle()
                                .fill(index == currentIndex ? .white : .white.opacity(0.3))
                                .frame(width: 6, height: 6)
                        }
                    }
                    .padding(.top, 10)
                }

                Spacer()

                HStack(spacing: 16) {

                    Button {
                        withAnimation {
                            currentIndex = max(currentIndex - 1, 0)
                        }
                    } label: {
                        Text("← Previous")
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(14)
                    }
                    .disabled(currentIndex == 0 || items.isEmpty)
                    .opacity(currentIndex == 0 || items.isEmpty ? 0.4 : 1)

                    Button {
                        withAnimation {
                            currentIndex = min(currentIndex + 1, items.count - 1)
                        }
                    } label: {
                        Text("Next →")
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(14)
                    }
                    .disabled(items.isEmpty || currentIndex >= items.count - 1)
                    .opacity(items.isEmpty || currentIndex >= items.count - 1 ? 0.4 : 1)
                }
                .padding(.bottom, 30)
            }
        }
        .onChange(of: items.count) { _ in
            currentIndex = 0
        }
        .onAppear {
            if let groupId = groupStore.selectedGroupId {
                activityStore.fetchTimeline(groupId: groupId)
            }
        }
    }
}
