import AVFoundation
import UIKit

/// Plays sounds from the asset catalog's data sets.
@MainActor
final class SoundPlayer {
    private static let flipSoundName = "sound/jump"

    private var player: AVAudioPlayer?
    private lazy var flipPlayer: AVAudioPlayer? = makePlayer(for: Self.flipSoundName)

    /// Plays a pack's sound, replacing whatever was playing.
    func play(_ soundName: String) {
        stop()
        player = makePlayer(for: soundName)
        player?.play()
    }

    func stop() {
        player?.stop()
        player = nil
    }

    /// Plays the card-turn sound from the start, even if it is still sounding.
    func playFlip() {
        flipPlayer?.currentTime = 0
        flipPlayer?.play()
    }

    private func makePlayer(for soundName: String) -> AVAudioPlayer? {
        guard let asset = NSDataAsset(name: soundName) else { return nil }
        // Ambient respects the silent switch and mixes with other audio.
        try? AVAudioSession.sharedInstance().setCategory(.ambient)
        let player = try? AVAudioPlayer(data: asset.data)
        player?.prepareToPlay()
        return player
    }
}
