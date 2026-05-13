# Pomidor

A minimal, native macOS menu bar Pomodoro timer built with Swift and SwiftUI.

Pomidor lives in your menu bar — no dock icon, no clutter. Just a clean timer that helps you focus.

## Download

Grab the latest **DMG** (recommended) or zip from [**Releases**](https://github.com/ervinpetrisevac-jpg/pomidor-macos/releases/latest): open the DMG, drag **Pomidor** into **Applications**, then eject the disk image.

Requires macOS 15 or later.

## Features

- **Menu bar native** — runs entirely from the status bar, hidden from the Dock
- **Pomodoro workflow** — 25 min work / 5 min short break / 15 min long break with session tracking
- **Visual progress ring** — animated circular indicator with color-coded sessions
- **Native notifications** — macOS alerts with sound when sessions complete
- **Customizable** — adjust all durations, auto-start behavior, and notification preferences
- **Lightweight** — pure Swift + SwiftUI, zero external dependencies
- **Dark mode** — adapts automatically via native system materials

## Requirements

- macOS 15.0 (Sequoia) or later
- Xcode 16.0+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) for project generation
- [create-dmg](https://github.com/create-dmg/create-dmg) (`brew install create-dmg`) only if you run `make distribution` or `make dmg`

## Getting Started

### Install XcodeGen

```bash
brew install xcodegen
```

### Release build (zip + DMG)

Produces `dist/Pomidor-<version>-macos-<arch>.zip` and `dist/Pomidor-<version>.dmg` (disk image with **Applications** shortcut). Attach both to a GitHub Release, or ship the DMG alone.

```bash
brew install create-dmg   # once
make distribution
```

To rebuild only the DMG after changing layout or version (expects `dist/Pomidor.app`):

```bash
make dmg
```

### Build & Run

```bash
# Generate Xcode project and build
make build

# Or generate and open in Xcode
make generate
open Pomidor.xcodeproj
```

### Development

```bash
make debug    # Debug build
make clean    # Clean build artifacts
```

## Project Structure

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

## Tech Stack

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
