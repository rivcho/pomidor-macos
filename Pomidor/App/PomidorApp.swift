import SwiftUI

@main
struct PomidorApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

// MARK: - AppDelegate

final class AppDelegate: NSObject, NSApplicationDelegate {

    private var timer: TimerManager!

    func applicationDidFinishLaunching(_ notification: Notification) {
        timer = TimerManager()
        NotificationManager.shared.requestPermission()
        StatusItemManager.shared.setup(timer: timer, settings: .shared)
    }
}
