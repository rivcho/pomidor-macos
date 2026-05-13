import SwiftUI

enum PomidorTheme {

    // MARK: - Color Tokens

    static let pomidorRed = Color(red: 0.95, green: 0.36, blue: 0.23)
    static let breakGreen = Color(red: 0.20, green: 0.72, blue: 0.60)
    static let longBreakBlue = Color(red: 0.36, green: 0.55, blue: 0.94)

    static let pomidorRedDark = Color(red: 0.85, green: 0.30, blue: 0.18)
    static let breakGreenDark = Color(red: 0.16, green: 0.62, blue: 0.52)
    static let longBreakBlueDark = Color(red: 0.30, green: 0.48, blue: 0.85)

    // MARK: - Spacing Scale (base-4 for compact UI)

    static let spacing2: CGFloat = 2
    static let spacing4: CGFloat = 4
    static let spacing6: CGFloat = 6
    static let spacing8: CGFloat = 8
    static let spacing12: CGFloat = 12
    static let spacing16: CGFloat = 16
    static let spacing20: CGFloat = 20
    static let spacing24: CGFloat = 24
    static let spacing32: CGFloat = 32

    // MARK: - Dimensions

    static let popoverWidth: CGFloat = 280
    static let progressRingSize: CGFloat = 160
    static let progressRingLineWidth: CGFloat = 6
    static let progressRingTrackOpacity: Double = 0.15
    static let controlButtonSize: CGFloat = 36
    static let sessionDotSize: CGFloat = 7
    static let settingsHeight: CGFloat = 420

    // MARK: - Corner Radii

    static let radiusSmall: CGFloat = 6
    static let radiusMedium: CGFloat = 10
    static let radiusLarge: CGFloat = 14

    // MARK: - Animation

    static let ringAnimation: Animation = .easeInOut(duration: 0.4)
    static let stateTransition: Animation = .easeInOut(duration: 0.25)
    static let microFeedback: Animation = .easeOut(duration: 0.15)

    // MARK: - Typography (SF Pro via system font)

    static let timerFont: Font = .system(size: 42, weight: .light, design: .monospaced)
    static let sessionLabelFont: Font = .system(size: 13, weight: .semibold, design: .rounded)
    static let captionFont: Font = .system(size: 11, weight: .medium, design: .rounded)
    static let controlFont: Font = .system(size: 14, weight: .medium)
    static let settingsHeaderFont: Font = .system(size: 13, weight: .semibold)
}

// MARK: - Session Color Mapping

extension PomidorTheme {
    static func accentColor(for state: TimerSessionType) -> Color {
        switch state {
        case .work: return pomidorRed
        case .shortBreak: return breakGreen
        case .longBreak: return longBreakBlue
        }
    }
}
