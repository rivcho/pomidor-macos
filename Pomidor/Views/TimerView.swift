import SwiftUI

struct TimerView: View {

    @Bindable var timer: TimerManager
    @ObservedObject var settings: PomidorSettings = .shared
    @State private var showSettings = false

    private var accent: Color {
        PomidorTheme.accentColor(for: timer.sessionType)
    }

    var body: some View {
        VStack(spacing: 0) {
            if showSettings {
                SettingsView(onBack: { showSettings = false })
                    .frame(height: PomidorTheme.settingsHeight)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            } else {
                timerContent
                    .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .frame(width: PomidorTheme.popoverWidth)
        .fixedSize(horizontal: false, vertical: !showSettings)
        .animation(PomidorTheme.stateTransition, value: showSettings)
    }

    // MARK: - Timer Content

    private var timerContent: some View {
        VStack(spacing: 0) {
            VStack(spacing: PomidorTheme.spacing20) {
                CircularProgressView(
                    progress: timer.progress,
                    accentColor: accent,
                    formattedTime: timer.formattedTime,
                    sessionLabel: timer.sessionType.shortLabel
                )
                .padding(.top, PomidorTheme.spacing32)

                SessionIndicator(
                    completed: timer.completedWorkSessions,
                    total: settings.sessionsBeforeLongBreak,
                    accentColor: accent
                )

                TimerControls(
                    phase: timer.phase,
                    accentColor: accent,
                    onPlayPause: timer.togglePlayPause,
                    onReset: timer.reset,
                    onSkip: timer.skip
                )
            }
            .padding(.horizontal, PomidorTheme.spacing24)
            .padding(.bottom, PomidorTheme.spacing20)

            Divider()
                .opacity(0.5)
                .padding(.horizontal, PomidorTheme.spacing12)

            VStack(spacing: PomidorTheme.spacing2) {
                FooterButton(label: "Settings", icon: "gearshape") {
                    showSettings = true
                }
                FooterButton(label: "Quit Pomidor", icon: "power") {
                    NSApplication.shared.terminate(nil)
                }
            }
            .padding(.vertical, PomidorTheme.spacing6)
            .padding(.horizontal, PomidorTheme.spacing8)
        }
    }
}

// MARK: - Footer Button

private struct FooterButton: View {

    let label: String
    let icon: String
    let action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: PomidorTheme.spacing8) {
                Image(systemName: icon)
                    .font(.system(size: 10, weight: .medium))
                    .frame(width: 14)

                Text(label)
                    .font(.system(size: 12, weight: .medium))

                Spacer()
            }
            .foregroundStyle(.secondary)
            .padding(.vertical, PomidorTheme.spacing4)
            .padding(.horizontal, PomidorTheme.spacing8)
            .background(
                isHovered
                    ? Color.primary.opacity(0.06)
                    : Color.clear,
                in: RoundedRectangle(cornerRadius: PomidorTheme.radiusSmall)
            )
            .contentShape(RoundedRectangle(cornerRadius: PomidorTheme.radiusSmall))
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(PomidorTheme.microFeedback) {
                isHovered = hovering
            }
        }
    }
}
