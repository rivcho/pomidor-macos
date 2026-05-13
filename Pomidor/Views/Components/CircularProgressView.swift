import SwiftUI

struct CircularProgressView: View {

    let progress: Double
    let accentColor: Color
    let formattedTime: String
    let sessionLabel: String

    private var clampedProgress: CGFloat {
        CGFloat(min(max(progress, 0), 1.0))
    }

    private var progressAngle: Angle {
        .degrees(360 * Double(clampedProgress) - 90)
    }

    var body: some View {
        ZStack {
            // Track ring
            Circle()
                .stroke(
                    accentColor.opacity(PomidorTheme.progressRingTrackOpacity),
                    style: StrokeStyle(
                        lineWidth: PomidorTheme.progressRingLineWidth,
                        lineCap: .round
                    )
                )

            // Progress ring
            Circle()
                .trim(from: 0, to: clampedProgress)
                .stroke(
                    accentColor,
                    style: StrokeStyle(
                        lineWidth: PomidorTheme.progressRingLineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: accentColor.opacity(0.35), radius: 8)
                .animation(PomidorTheme.ringAnimation, value: progress)

            // Leading edge dot
            if clampedProgress > 0.01 {
                Circle()
                    .fill(accentColor)
                    .frame(width: PomidorTheme.progressRingLineWidth + 2,
                           height: PomidorTheme.progressRingLineWidth + 2)
                    .shadow(color: accentColor.opacity(0.5), radius: 4)
                    .offset(y: -PomidorTheme.progressRingSize / 2)
                    .rotationEffect(progressAngle + .degrees(90))
                    .animation(PomidorTheme.ringAnimation, value: progress)
            }

            // Center content
            VStack(spacing: PomidorTheme.spacing4) {
                Text(sessionLabel)
                    .font(PomidorTheme.captionFont)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)

                Text(formattedTime)
                    .font(PomidorTheme.timerFont)
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText())
                    .monospacedDigit()
            }
        }
        .frame(
            width: PomidorTheme.progressRingSize,
            height: PomidorTheme.progressRingSize
        )
    }
}
