import AVFoundation
import UIKit

/// Plays a pack's sound from the asset catalog's data sets.
@MainActor
final class SoundPlayer {
    private var player: AVAudioPlayer?

    func play(_ soundName: String) {
        stop()
        guard let asset = NSDataAsset(name: soundName) else { return }
        // Ambient respects the silent switch and mixes with other audio.
        try? AVAudioSession.sharedInstance().setCategory(.ambient)
        player = try? AVAudioPlayer(data: asset.data)
        player?.play()
    }

    func stop() {
        player?.stop()
        player = nil
    }
}
