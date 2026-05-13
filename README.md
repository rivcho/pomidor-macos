# Pomidor

A minimal, native macOS menu bar Pomodoro timer built with Swift and SwiftUI.

Pomidor lives in your menu bar — no dock icon, no clutter. Just a clean timer that helps you focus.

## Install

1. Open the [**latest release**](https://github.com/ervinpetrisevac-jpg/pomidor-macos/releases/latest) and download the **DMG**.
2. Open the DMG, drag **Pomidor** into **Applications**, then eject the disk image.
3. Launch **Pomidor** from Applications. The timer appears in the menu bar (no Dock icon).

**Compatibility:** macOS 15 (Sequoia) or later.

If macOS shows a warning because the app is not from the Mac App Store, open **System Settings → Privacy & Security** and choose **Open Anyway**, or right-click the app → **Open** once to confirm you trust it.

## Features

- **Menu bar native** — runs entirely from the status bar, hidden from the Dock
- **Pomodoro workflow** — 25 min work / 5 min short break / 15 min long break with session tracking
- **Visual progress ring** — animated circular indicator with color-coded sessions
- **Native notifications** — macOS alerts with sound when sessions complete
- **Customizable** — adjust all durations, auto-start behavior, and notification preferences
- **Lightweight** — pure Swift + SwiftUI, zero external dependencies
- **Dark mode** — adapts automatically via native system materials

## Development

To build and run from this repository you need Xcode 16+ and [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`).

```bash
make build          # generate project + Release build
make generate && open Pomidor.xcodeproj   # open in Xcode
make debug          # Debug configuration
make clean          # remove build artifacts
```

Release artifacts for GitHub (DMG + zip) are produced with `make distribution`, which expects `create-dmg` on your PATH (`brew install create-dmg`).

## Project structure

```
Pomidor/
├── App/PomidorApp.swift              # Entry point, MenuBarExtra scene
├── Models/
│   ├── TimerState.swift              # Session types and timer phases
│   └── PomidorSettings.swift         # Persisted user preferences
├── Services/
│   ├── TimerManager.swift            # Core timer engine (@Observable)
│   ├── NotificationManager.swift     # macOS notification delivery
│   └── SoundManager.swift            # Completion sounds
├── Views/
│   ├── TimerView.swift               # Main popover UI
│   ├── SettingsView.swift            # Preferences window
│   └── Components/
│       ├── CircularProgressView.swift
│       ├── TimerControls.swift
│       └── SessionIndicator.swift
└── Theme/PomidorTheme.swift          # Design tokens
```

## Tech stack

| Layer | Choice |
|-------|--------|
| Language | Swift 5.9+ |
| UI | SwiftUI (MenuBarExtra) |
| State | @Observable macro |
| Persistence | @AppStorage / UserDefaults |
| Notifications | UserNotifications framework |
| Build | XcodeGen + xcodebuild |

## License

MIT
