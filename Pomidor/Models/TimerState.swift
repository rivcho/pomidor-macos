import Foundation

enum TimerSessionType: String, CaseIterable, Codable {
    case work
    case shortBreak
    case longBreak

    var label: String {
        switch self {
        case .work: return "Work Session"
        case .shortBreak: return "Short Break"
        case .longBreak: return "Long Break"
        }
    }

    var shortLabel: String {
        switch self {
        case .work: return "Work"
        case .shortBreak: return "Break"
        case .longBreak: return "Long Break"
        }
    }
}

enum TimerPhase: Equatable {
    case idle
    case running
    case paused
    case finished
}
