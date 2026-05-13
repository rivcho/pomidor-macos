import Foundation
import Combine
import SwiftUI

@Observable
final class TimerManager {

    // MARK: - Published State

    var phase: TimerPhase = .idle
    var sessionType: TimerSessionType = .work
    var remainingSeconds: TimeInterval = 25 * 60
    var totalSeconds: TimeInterval = 25 * 60
    var completedWorkSessions: Int = 0

    // MARK: - Computed

    var progress: Double {
        guard totalSeconds > 0 else { return 0 }
        return 1.0 - (remainingSeconds / totalSeconds)
    }

    var formattedTime: String {
        let minutes = Int(remainingSeconds) / 60
        let seconds = Int(remainingSeconds) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    var menuBarText: String {
        guard phase == .running || phase == .paused else { return "" }
        return formattedTime
    }

    var isRunning: Bool { phase == .running }

    // MARK: - Dependencies

    private let settings: PomidorSettings
    private let notificationManager: NotificationManager
    private let soundManager: SoundManager
    private var timerCancellable: AnyCancellable?
    private var settingsCancellable: AnyCancellable?

    init(
        settings: PomidorSettings = .shared,
        notificationManager: NotificationManager = .shared,
        soundManager: SoundManager = .shared
    ) {
        self.settings = settings
        self.notificationManager = notificationManager
        self.soundManager = soundManager
        resetToSession(.work)
        observeSettings()
    }

    private func observeSettings() {
        settingsCancellable = settings.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                if self.phase == .idle || self.phase == .finished {
                    let newDuration = self.settings.duration(for: self.sessionType)
                    self.totalSeconds = newDuration
                    self.remainingSeconds = newDuration
                }
            }
    }

    // MARK: - Controls

    func start() {
        guard phase == .idle || phase == .paused || phase == .finished else { return }

        if phase == .idle || phase == .finished {
            resetToSession(sessionType)
        }

        phase = .running
        startTicking()
    }

    func pause() {
        guard phase == .running else { return }
        phase = .paused
        stopTicking()
    }

    func togglePlayPause() {
        if phase == .running {
            pause()
        } else {
            start()
        }
    }

    func skip() {
        stopTicking()
        if sessionType == .work {
            completedWorkSessions += 1
        }
        let next = nextSessionType()
        sessionType = next
        resetToSession(next)
        phase = .idle
    }

    func reset() {
        stopTicking()
        phase = .idle
        completedWorkSessions = 0
        resetToSession(.work)
    }

    // MARK: - Timer Engine

    private func startTicking() {
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    private func stopTicking() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func tick() {
        guard remainingSeconds > 0 else { return }
        remainingSeconds -= 1

        if remainingSeconds <= 0 {
            onSessionComplete()
        }
    }

    // MARK: - Session Management

    private func onSessionComplete() {
        stopTicking()
        phase = .finished

        if sessionType == .work {
            completedWorkSessions += 1
        }

        if settings.playSoundOnComplete {
            soundManager.playCompletionSound()
        }

        if settings.showNotifications {
            notificationManager.sendSessionComplete(sessionType: sessionType)
        }

        let nextSession = nextSessionType()
        let shouldAutoStart = (nextSession == .work && settings.autoStartWork)
            || (nextSession != .work && settings.autoStartBreaks)

        sessionType = nextSession
        resetToSession(nextSession)

        if shouldAutoStart {
            start()
        }
    }

    private func nextSessionType() -> TimerSessionType {
        switch sessionType {
        case .work:
            if completedWorkSessions >= settings.sessionsBeforeLongBreak {
                return .longBreak
            }
            return .shortBreak
        case .shortBreak, .longBreak:
            if sessionType == .longBreak {
                completedWorkSessions = 0
            }
            return .work
        }
    }

    private func resetToSession(_ session: TimerSessionType) {
        sessionType = session
        let duration = settings.duration(for: session)
        totalSeconds = duration
        remainingSeconds = duration
    }
}
