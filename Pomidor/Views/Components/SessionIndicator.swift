import SwiftUI

struct SessionIndicator: View {

    let completed: Int
    let total: Int
    let accentColor: Color

    var body: some View {
        HStack(spacing: PomidorTheme.spacing8) {
            HStack(spacing: PomidorTheme.spacing4) {
                ForEach(0..<total, id: \.self) { index in
                    if index < completed {
                        Circle()
                            .fill(accentColor)
                            .frame(
                                width: PomidorTheme.sessionDotSize,
                                height: PomidorTheme.sessionDotSize
                            )
                    } else {
                        Circle()
                            .stroke(accentColor.opacity(0.35), lineWidth: 1.5)
                            .frame(
                                width: PomidorTheme.sessionDotSize,
                                height: PomidorTheme.sessionDotSize
                            )
                    }
                }
            }
            .animation(PomidorTheme.stateTransition, value: completed)

            Text("\(completed)/\(total)")
                .font(PomidorTheme.captionFont)
                .foregroundStyle(.tertiary)
                .monospacedDigit()
        }
    }
}
