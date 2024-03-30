//
// Created by MAC on 2023/11/16.
//

import Foundation
import AVFAudio

class AudioSession {

    static private var _shareInstance: AudioSession!

    static var shareInstance: AudioSession {
        if _shareInstance == nil {
            _shareInstance = AudioSession()
            try? AVAudioSession.sharedInstance().setCategory(.ambient)
            try? AVAudioSession.sharedInstance().setActive(true)
        }
        return _shareInstance
    }

    var players: [AudioPlayer] = []


    @discardableResult
    func play(_ player: AudioPlayer) -> Bool {
        if active(with: player.category) {
            let playingItems = players.filter({ $0.category == player.category && $0.isPlaying })
            if playingItems.filter({ $0.priority > player.priority }).count == 0 {
                player.systemPlayer.volume = player.targetVolume
                playingItems.filter({ $0.priority < player.priority }).forEach({ $0.systemPlayer.setVolume(0, fadeDuration: 0.5) })
            } else {
                player.systemPlayer.volume = 0
            }
        } else {
            player.systemPlayer.volume = 0
        }

        logger.debug("[AUDIO] PLAY \(player.fileName)  \(player.category.rawValue) volume:\(player.volume)")

        players.append(player)
        player.systemPlayer.prepareToPlay()
        return player.systemPlayer.play()
    }

    func pause(_ player: AudioPlayer) {
        player.systemPlayer.pause()
    }

    func stop(_ player: AudioPlayer) {
        player.systemPlayer.stop()

        if let idx = players.firstIndex(of: player) {
            players.remove(at: idx)
        }

        let categoryPlayers = players.filter({ $0.category == player.category })
        if categoryPlayers.filter({ $0.priority > player.priority }).count == 0 {
            if let max = categoryPlayers.max(by: { $0.priority < $1.priority }) {
                categoryPlayers.filter({ $0.priority == max.priority && $0.volume != $0.targetVolume })
                        .forEach({ $0.setVolume($0.targetVolume, fadeDuration: 0.5) })
            }
        }
    }

    func setVolume(_ player: AudioPlayer, volume: Float, fadeDuration: TimeInterval) {
        player.targetVolume = volume
        if active(with: player.category) && volume > 0 {
            let categoryPlayers = players.filter({ $0.category == player.category })
            if categoryPlayers.filter({ $0.priority > player.priority }).count == 0 {
                if fadeDuration > 0 {
                    player.systemPlayer.setVolume(volume, fadeDuration: fadeDuration)
                } else {
                    player.systemPlayer.volume = volume
                }
            }
        }
    }


    func active(with category: Category) -> Bool {
        let value = UserDefaults.standard.object(forKey: category.rawValue)
        if let val = value as? Int {
            return val == 1
        }
        return true
    }

    func setActive(_ active: Bool, with category: Category) {
        UserDefaults.standard.set(active, forKey: category.rawValue)
        UserDefaults.standard.synchronize()
        let categoryPlayers = players.filter({ $0.category == category })
        if active {
            if let max = categoryPlayers.max(by: { $0.priority < $1.priority }) {
                categoryPlayers.filter({ $0.priority == max.priority })
                        .forEach({ $0.systemPlayer.setVolume($0.targetVolume, fadeDuration: 0.5) })
            }
        } else {
            categoryPlayers.forEach({ $0.systemPlayer.volume = 0 })
        }
    }



}

extension AudioSession {

    struct Category: RawRepresentable {

        private(set) var rawValue: String

        init(rawValue: String) {
            self.rawValue = rawValue
        }

        init(_ rawValue: String) {
            self.rawValue = rawValue
        }

    }

}

extension AudioSession.Category {
    static let `default` = AudioSession.Category("AudioSessionCategoryDefault")
    static let music = AudioSession.Category("AudioSessionCategoryMusic")
}
