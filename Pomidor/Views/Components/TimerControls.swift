import SwiftUI

struct TimerControls: View {

    let phase: TimerPhase
    let accentColor: Color
    let onPlayPause: () -> Void
    let onReset: () -> Void
    let onSkip: () -> Void

    var body: some View {
        HStack(spacing: 28) {
            ControlButton(
                icon: "arrow.counterclockwise",
                label: "Reset",
                action: onReset
            )

            Button(action: onPlayPause) {
                Image(systemName: playPauseIcon)
                    .font(.system(size: 18, weight: .semibold))
                    .frame(
                        width: PomidorTheme.controlButtonSize + 8,
                        height: PomidorTheme.controlButtonSize + 8
                    )
                    .foregroundStyle(.white)
                    .background(accentColor, in: Circle())
                    .shadow(color: accentColor.opacity(0.3), radius: 6, y: 2)
                    .contentShape(Circle())
            }
            .buttonStyle(.plain)
            .contentTransition(.symbolEffect(.replace))

            ControlButton(
                icon: "forward.end.fill",
                label: "Skip",
                action: onSkip
            )
        }
    }

    private var playPauseIcon: String {
        phase == .running ? "pause.fill" : "play.fill"
    }
}

// MARK: - Secondary Control Button

private struct ControlButton: View {

    let icon: String
    let label: String
    let action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .frame(
                    width: PomidorTheme.controlButtonSize,
                    height: PomidorTheme.controlButtonSize
                )
                .foregroundStyle(.secondary)
                .background(
                    Color.primary.opacity(isHovered ? 0.08 : 0.04),
                    in: Circle()
                )
                .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(PomidorTheme.microFeedback) {
                isHovered = hovering
            }
        }
        .help(label)
    }
}
