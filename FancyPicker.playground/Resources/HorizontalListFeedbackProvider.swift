import UIKit
import Foundation

struct HorizontalListFeedbackProvider {
    private let hapticFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
//    private let soundPlayer = SoundPlayer(file: "click")

    func provideFeedback() {
        playHapticFeedback()
//        playSoundFeedback()
    }

    private func playHapticFeedback() {
        hapticFeedbackGenerator.impactOccurred()
    }

    private func playSoundFeedback() {
//        soundPlayer.play()
    }
}
