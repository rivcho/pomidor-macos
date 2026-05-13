import AppKit
import SwiftUI
import Combine

@MainActor
final class StatusItemManager: NSObject {

    static let shared = StatusItemManager()

    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var updateCancellable: AnyCancellable?

    private var timer: TimerManager?
    private var settings: PomidorSettings?
    private var lastPhase: TimerPhase = .idle

    private override init() {
        super.init()
    }

    func setup(timer: TimerManager, settings: PomidorSettings) {
        self.timer = timer
        self.settings = settings

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            let image = NSImage(named: "MenuBarIdle")
            image?.isTemplate = true
            image?.size = NSSize(width: 18, height: 18)
            button.image = image
            button.action = #selector(togglePopover)
            button.target = self
        }

        let popover = NSPopover()
        popover.contentSize = NSSize(width: 280, height: 380)
        popover.behavior = .transient
        popover.animates = true
        popover.contentViewController = NSHostingController(
            rootView: TimerView(timer: timer)
        )
        self.popover = popover

        updateCancellable = Timer.publish(every: 0.5, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateButton()
            }
        updateButton()
    }

    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }

        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }

    private func updateButton() {
        guard let timer, let settings, let button = statusItem.button else { return }

        let currentPhase = timer.phase

        // Auto-close popover when user starts or resets the timer
        if popover.isShown && currentPhase != lastPhase {
            if currentPhase == .running || (currentPhase == .idle && lastPhase != .idle) {
                popover.performClose(nil)
            }
        }
        lastPhase = currentPhase

        let showTime = settings.showTimeInMenuBar
            && (currentPhase == .running || currentPhase == .paused)

        let buttonImage: NSImage?
        switch currentPhase {
        case .idle:
            let img = NSImage(named: "MenuBarIdle")
            img?.isTemplate = true
            img?.size = NSSize(width: 18, height: 18)
            buttonImage = img
        case .running:
            switch timer.sessionType {
            case .work:
                buttonImage = NSImage(systemSymbolName: "flame.fill", accessibilityDescription: "Work")
            case .shortBreak, .longBreak:
                buttonImage = NSImage(systemSymbolName: "leaf.fill", accessibilityDescription: "Break")
            }
        case .paused:
            buttonImage = NSImage(systemSymbolName: "pause.circle", accessibilityDescription: "Paused")
        case .finished:
            buttonImage = NSImage(systemSymbolName: "checkmark.circle", accessibilityDescription: "Finished")
        }

        button.image = buttonImage

        if showTime {
            button.title = " \(timer.formattedTime)"
            button.imagePosition = .imageLeading
            button.font = NSFont.monospacedDigitSystemFont(
                ofSize: NSFont.systemFontSize(for: .small),
                weight: .medium
            )
        } else {
            button.title = ""
            button.imagePosition = .imageOnly
        }
    }
}
