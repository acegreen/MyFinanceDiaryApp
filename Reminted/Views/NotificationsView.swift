import Inject
import SwiftUI

struct NotificationItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let timestamp: Date
    let isRead: Bool
}

struct NotificationsView: View {
    @ObserveInjection var inject
    @State private var notifications: [NotificationItem] = [
        NotificationItem(
            title: "New Message",
            message: "You have a new message from John",
            timestamp: Date(),
            isRead: false
        ),
        NotificationItem(
            title: "Reminder",
            message: "Team meeting in 30 minutes",
            timestamp: Date().addingTimeInterval(-3600),
            isRead: true
        ),
    ]

    enum NotificationDestination: Hashable {
        case notifications
    }

    var body: some View {
        List {
            ForEach(notifications) { notification in
                NotificationRow(notification: notification)
            }
        }
        .navigationTitle("Notifications")
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(Color.darkGreen, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton()
            }
            ToolbarItem(placement: .principal) {
                EmptyView()
            }
        }
        .listStyle(.grouped)
        .enableInjection()
    }
}

struct NotificationRow: View {
    let notification: NotificationItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(notification.title)
                    .font(.headline)

                Spacer()

                Text(notification.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text(notification.message)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
        .opacity(notification.isRead ? 0.8 : 1)
    }
}

#Preview {
    NavigationStack {
        NotificationsView()
    }
}
