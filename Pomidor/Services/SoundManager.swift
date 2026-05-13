import AppKit

final class SoundManager {

    static let shared = SoundManager()

    private init() {}

    func playCompletionSound() {
        if let sound = NSSound(named: "Glass") {
            sound.play()
        } else {
            NSSound.beep()
        }
    }
}
