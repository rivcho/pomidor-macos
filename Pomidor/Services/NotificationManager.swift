import UserNotifications

final class NotificationManager {

    static let shared = NotificationManager()

    private init() {}

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    func sendSessionComplete(sessionType: TimerSessionType) {
        let content = UNMutableNotificationContent()

        switch sessionType {
        case .work:
            content.title = "Work session complete"
            content.body = "Time for a break. You've earned it."
        case .shortBreak:
            content.title = "Break is over"
            content.body = "Ready to focus again?"
        case .longBreak:
            content.title = "Long break is over"
            content.body = "Full cycle complete. Let's go again."
        }

        content.sound = .default

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter.current().add(request)
    }
}
