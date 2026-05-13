import SwiftUI

struct SettingsView: View {

    @ObservedObject var settings: PomidorSettings = .shared
    var onBack: () -> Void

    @State private var backHovered = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: onBack) {
                    HStack(spacing: PomidorTheme.spacing4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 11, weight: .bold))
                        Text("Back")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundStyle(backHovered ? .primary : .secondary)
                    .padding(.vertical, PomidorTheme.spacing4)
                    .padding(.horizontal, PomidorTheme.spacing6)
                    .background(
                        backHovered ? Color.primary.opacity(0.06) : Color.clear,
                        in: RoundedRectangle(cornerRadius: PomidorTheme.radiusSmall)
                    )
                }
                .buttonStyle(.plain)
                .onHover { h in withAnimation(PomidorTheme.microFeedback) { backHovered = h } }

                Spacer()

                Text("Settings")
                    .font(PomidorTheme.sessionLabelFont)

                Spacer()

                Color.clear.frame(width: 56, height: 1)
            }
            .padding(.horizontal, PomidorTheme.spacing12)
            .padding(.top, PomidorTheme.spacing12)
            .padding(.bottom, PomidorTheme.spacing8)

            Divider()
                .opacity(0.5)
                .padding(.horizontal, PomidorTheme.spacing12)

            // Content
            ScrollView {
                VStack(spacing: PomidorTheme.spacing20) {
                    SettingsSection(title: "Durations") {
                        DurationSliderRow(
                            label: "Work",
                            value: $settings.workDuration,
                            range: 1...90,
                            unit: "min",
                            accentColor: PomidorTheme.pomidorRed
                        )
                        RowDivider()
                        DurationSliderRow(
                            label: "Short break",
                            value: $settings.shortBreakDuration,
                            range: 1...30,
                            unit: "min",
                            accentColor: PomidorTheme.breakGreen
                        )
                        RowDivider()
                        DurationSliderRow(
                            label: "Long break",
                            value: $settings.longBreakDuration,
                            range: 1...60,
                            unit: "min",
                            accentColor: PomidorTheme.longBreakBlue
                        )
                        RowDivider()
                        DurationSliderRow(
                            label: "Sessions",
                            value: $settings.sessionsBeforeLongBreak,
                            range: 2...10,
                            unit: "",
                            accentColor: PomidorTheme.pomidorRed
                        )
                        ResetDefaultsButton {
                            settings.resetToDefaults()
                        }
                    }

                    SettingsSection(title: "Automation") {
                        ToggleRow(label: "Auto-start breaks", isOn: $settings.autoStartBreaks)
                        RowDivider()
                        ToggleRow(label: "Auto-start work", isOn: $settings.autoStartWork)
                    }

                    SettingsSection(title: "Appearance") {
                        ToggleRow(label: "Time in menu bar", isOn: $settings.showTimeInMenuBar)
                        RowDivider()
                        LaunchAtLoginRow()
                    }

                    SettingsSection(title: "Notifications") {
                        ToggleRow(label: "Sound on completion", isOn: $settings.playSoundOnComplete)
                        RowDivider()
                        ToggleRow(label: "Show notifications", isOn: $settings.showNotifications)
                    }

                    AboutSection()
                }
                .padding(.horizontal, PomidorTheme.spacing12)
                .padding(.top, PomidorTheme.spacing16)
                .padding(.bottom, PomidorTheme.spacing20)
            }
        }
    }
}

// MARK: - Settings Section

private struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: PomidorTheme.spacing6) {
            Text(title.uppercased())
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundStyle(.tertiary)
                .tracking(0.8)
                .padding(.leading, PomidorTheme.spacing8)

            VStack(spacing: 0) {
                content
            }
            .padding(.horizontal, PomidorTheme.spacing4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Color.primary.opacity(0.03),
                in: RoundedRectangle(cornerRadius: PomidorTheme.radiusMedium)
            )
        }
    }
}

private struct RowDivider: View {
    var body: some View {
        Divider()
            .opacity(0.5)
            .padding(.leading, PomidorTheme.spacing8)
    }
}

// MARK: - Duration Slider Row

private struct DurationSliderRow: View {
    let label: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let unit: String
    let accentColor: Color

    @State private var isExpanded = false
    @State private var sliderValue: Double = 0
    @State private var isHovered = false

    private var displayValue: String {
        unit.isEmpty ? "\(value)" : "\(value) \(unit)"
    }

    var body: some View {
        VStack(spacing: 0) {
            Button {
                sliderValue = Double(value)
                isExpanded.toggle()
            } label: {
                HStack {
                    Text(label)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.primary)

                    Spacer()

                    Text(displayValue)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(isExpanded ? accentColor : .secondary)
                        .monospacedDigit()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(.quaternary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(.vertical, PomidorTheme.spacing8)
                .padding(.horizontal, PomidorTheme.spacing8)
                .background(
                    isHovered ? Color.primary.opacity(0.03) : Color.clear,
                    in: RoundedRectangle(cornerRadius: PomidorTheme.radiusSmall)
                )
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .onHover { h in withAnimation(PomidorTheme.microFeedback) { isHovered = h } }

            if isExpanded {
                Slider(
                    value: $sliderValue,
                    in: Double(range.lowerBound)...Double(range.upperBound)
                )
                .tint(accentColor)
                .controlSize(.small)
                .onChange(of: sliderValue) { _, newVal in
                    value = Int(newVal.rounded())
                }
                .padding(.horizontal, PomidorTheme.spacing8)
                .padding(.bottom, PomidorTheme.spacing8)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
        .onAppear { sliderValue = Double(value) }
    }
}

// MARK: - Toggle Row

private struct ToggleRow: View {
    let label: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 13, weight: .regular))
                .lineLimit(1)

            Spacer(minLength: PomidorTheme.spacing8)

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(.switch)
                .controlSize(.small)
        }
        .padding(.vertical, PomidorTheme.spacing8)
        .padding(.horizontal, PomidorTheme.spacing8)
    }
}

// MARK: - Reset Defaults Button

private struct ResetDefaultsButton: View {
    let action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: PomidorTheme.spacing4) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 10, weight: .medium))
                Text("Reset to defaults")
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundStyle(isHovered ? .primary : .tertiary)
            .padding(.vertical, PomidorTheme.spacing6)
            .frame(maxWidth: .infinity)
            .background(
                isHovered ? Color.primary.opacity(0.03) : Color.clear,
                in: RoundedRectangle(cornerRadius: PomidorTheme.radiusSmall)
            )
        }
        .buttonStyle(.plain)
        .onHover { h in withAnimation(PomidorTheme.microFeedback) { isHovered = h } }
    }
}

// MARK: - Launch at Login

private struct LaunchAtLoginRow: View {
    @State private var isEnabled = LaunchAtLoginManager.isEnabled

    var body: some View {
        HStack {
            Text("Launch at login")
                .font(.system(size: 13, weight: .regular))
                .lineLimit(1)

            Spacer(minLength: PomidorTheme.spacing8)

            Toggle("", isOn: $isEnabled)
                .labelsHidden()
                .toggleStyle(.switch)
                .controlSize(.small)
                .onChange(of: isEnabled) { _, newValue in
                    LaunchAtLoginManager.setEnabled(newValue)
                }
        }
        .padding(.vertical, PomidorTheme.spacing8)
        .padding(.horizontal, PomidorTheme.spacing8)
    }
}

// MARK: - About Section

private struct AboutSection: View {
    @State private var isExpanded = false
    @State private var isHovered = false

    var body: some View {
        VStack(alignment: .leading, spacing: PomidorTheme.spacing6) {
            Text("ABOUT")
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundStyle(.tertiary)
                .tracking(0.8)
                .padding(.leading, PomidorTheme.spacing8)

            VStack(alignment: .leading, spacing: 0) {
                Button {
                    isExpanded.toggle()
                } label: {
                    HStack(spacing: PomidorTheme.spacing8) {
                        Text("What is Pomodoro?")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.primary)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(.quaternary)
                            .rotationEffect(.degrees(isExpanded ? 90 : 0))
                    }
                    .padding(.vertical, PomidorTheme.spacing8)
                    .padding(.horizontal, PomidorTheme.spacing8)
                    .background(
                        isHovered ? Color.primary.opacity(0.03) : Color.clear,
                        in: RoundedRectangle(cornerRadius: PomidorTheme.radiusSmall)
                    )
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .onHover { h in withAnimation(PomidorTheme.microFeedback) { isHovered = h } }

                if isExpanded {
                    VStack(alignment: .leading, spacing: PomidorTheme.spacing12) {
                        Text("The Pomodoro Technique is a time management method developed by Francesco Cirillo in the late 1980s.")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineSpacing(2)

                        VStack(alignment: .leading, spacing: PomidorTheme.spacing6) {
                            StepRow(number: "1", text: "Pick a task to work on")
                            StepRow(number: "2", text: "Set a 25-minute timer")
                            StepRow(number: "3", text: "Work with full focus until it rings")
                            StepRow(number: "4", text: "Take a short 5-minute break")
                            StepRow(number: "5", text: "Every 4 sessions, take a longer break")
                        }

                        Text("\"Pomodoro\" is Italian for tomato — named after the tomato-shaped kitchen timer Cirillo used as a student.")
                            .font(.system(size: 10, weight: .regular))
                            .foregroundStyle(.tertiary)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineSpacing(2)
                    }
                    .padding(.horizontal, PomidorTheme.spacing8)
                    .padding(.bottom, PomidorTheme.spacing12)
                    .transition(.opacity)
                }
            }
            .padding(.horizontal, PomidorTheme.spacing4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Color.primary.opacity(0.03),
                in: RoundedRectangle(cornerRadius: PomidorTheme.radiusMedium)
            )

            VStack(spacing: 2) {
                Text("Pomidor v1.0")
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundStyle(.quaternary)

                Link("Ervin Petrisevac", destination: URL(string: "https://www.linkedin.com/in/ervin-petrisevac/")!)
                    .font(.system(size: 9, weight: .medium, design: .rounded))
                    .foregroundStyle(.quaternary)
            }
            .frame(maxWidth: .infinity)
            .padding(.top, PomidorTheme.spacing4)
        }
        .animation(.easeInOut(duration: 0.2), value: isExpanded)
    }
}

private struct StepRow: View {
    let number: String
    let text: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: PomidorTheme.spacing8) {
            Text(number)
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundStyle(PomidorTheme.pomidorRed)
                .frame(width: 12, alignment: .trailing)

            Text(text)
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(.secondary)
        }
    }
}
