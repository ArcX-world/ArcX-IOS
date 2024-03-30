//
// Created by MAC on 2023/11/16.
//

import Foundation
import AVFAudio

typealias CompletionHandler = () -> Void

class AudioPlayer: NSObject, AVAudioPlayerDelegate {

    let fileName: String
    let category: AudioSession.Category
    let loops: Int
    let priority: Float
    var targetVolume: Float
    var completionHandler: CompletionHandler?
    let systemPlayer: AVAudioPlayer


    convenience init?(fileName: String, category: AudioSession.Category = .default, loops: Int = 0, volume: Float = 1.0, priority: Float = 500, completionHandler: CompletionHandler? = nil) {
        let components: [String] = fileName.split(separator: ".").compactMap({ "\($0)" })
        guard components.count == 2 else {
            logger.info("[AV] file not found, \(fileName)")
            return nil
        }
        guard let fileURL = Bundle.main.url(forResource: components[0], withExtension: components[1]) else {
            logger.info("[AV] file not found, \(fileName)")
            return nil
        }
        self.init(fileURL: fileURL, category: category, loops: loops, volume: volume, priority: priority, completionHandler: completionHandler)
    }

    init?(fileURL: URL, category: AudioSession.Category = .default, loops: Int = 0, volume: Float = 1.0, priority: Float = 500, completionHandler: CompletionHandler? = nil) {
        guard let player = try? AVAudioPlayer(contentsOf: fileURL) else {
            logger.info("[AV] file not found, \(fileURL.absoluteString)")
            return nil
        }
        systemPlayer = player
        systemPlayer.numberOfLoops = loops
        self.fileName = fileURL.lastPathComponent
        self.category = category
        self.loops = loops
        self.priority = priority
        self.targetVolume = volume
        super.init()
        systemPlayer.delegate = self
        self.completionHandler = completionHandler
    }


    // MARK: - Public

    var isPlaying: Bool {
        return systemPlayer.isPlaying
    }

    var volume: Float {
        get { systemPlayer.volume }
    }

    @discardableResult
    func prepareToPlay() -> Bool {
        return systemPlayer.prepareToPlay()
    }

    @discardableResult
    func play() -> Self {
        let _ = AudioSession.shareInstance.play(self)
        return self
    }

    func pause() {
        AudioSession.shareInstance.pause(self)
    }

    func stop() {
        AudioSession.shareInstance.stop(self)
    }

    func setVolume(_ volume: Float, fadeDuration: TimeInterval = 0) {
        AudioSession.shareInstance.setVolume(self, volume: volume, fadeDuration: 0)
    }

    // MARK: - AVAudioPlayerDelegate

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        AudioSession.shareInstance.stop(self)
        if flag {
            completionHandler?()
        }
    }

    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        AudioSession.shareInstance.stop(self)
    }

}
