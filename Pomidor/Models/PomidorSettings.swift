import SwiftUI

final class PomidorSettings: ObservableObject {

    static let shared = PomidorSettings()

    @AppStorage("workDuration") var workDuration: Int = 25
    @AppStorage("shortBreakDuration") var shortBreakDuration: Int = 5
    @AppStorage("longBreakDuration") var longBreakDuration: Int = 15
    @AppStorage("sessionsBeforeLongBreak") var sessionsBeforeLongBreak: Int = 4
    @AppStorage("autoStartBreaks") var autoStartBreaks: Bool = false
    @AppStorage("autoStartWork") var autoStartWork: Bool = false
    @AppStorage("showTimeInMenuBar") var showTimeInMenuBar: Bool = true
    @AppStorage("playSoundOnComplete") var playSoundOnComplete: Bool = true
    @AppStorage("showNotifications") var showNotifications: Bool = true
    @AppStorage("launchAtLogin") var launchAtLogin: Bool = false

    static let defaultWork = 25
    static let defaultShortBreak = 5
    static let defaultLongBreak = 15
    static let defaultSessions = 4

    func duration(for session: TimerSessionType) -> TimeInterval {
        switch session {
        case .work: return TimeInterval(workDuration * 60)
        case .shortBreak: return TimeInterval(shortBreakDuration * 60)
        case .longBreak: return TimeInterval(longBreakDuration * 60)
        }
    }

    func resetToDefaults() {
        workDuration = Self.defaultWork
        shortBreakDuration = Self.defaultShortBreak
        longBreakDuration = Self.defaultLongBreak
        sessionsBeforeLongBreak = Self.defaultSessions
    }

    private init() {}
}
