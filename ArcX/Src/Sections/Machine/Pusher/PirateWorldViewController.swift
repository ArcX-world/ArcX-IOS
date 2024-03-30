//
// Created by LLL on 2024/3/26.
//

import UIKit
import SwiftyJSON

class PirateWorldViewController: PusherMachineViewController {

    private var audios: [Int: AudioPlayer] = [:]
    private var eventTimers: [Timer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        audios[0] = AudioPlayer(fileName: "c3acd2f9c6fb1fa517ef312b734f3434.mp3", category: .music, loops: -1)!.play()
    }

    override func destroy() {
        super.destroy()
        eventTimers.forEach({ $0.invalidate() })
        eventTimers.removeAll()
        audios.values.forEach({ $0.stop() })
        audios.removeAll()
    }

    override func webSocket(_ webSocket: WebSocket, didReceiveJson json: JSON) {
        super.webSocket(webSocket, didReceiveJson: json)
        let cmd = json["cmd"].intValue
        let data = json["param"]["serverMsg"]
        if cmd == CMD_S2C_DEFAULT {
            if data["optTp"].int == SocketSignal.START_GAME {
                handleEvent(JSON([ "voiceType": 0 ]))
            }
        } else if cmd == SocketCMD.S2C.MCH_VOICE_EVENT {
            let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                if let index = self.eventTimers.firstIndex(of: timer) {
                    self.eventTimers.remove(at: index)
                }
                self.handleEvent(data)
            }
            eventTimers.append(timer)
        }
    }

    private func handleEvent(_ data: JSON) {
        let event = data["voiceType"].intValue
        let isStart = data["isStart"].boolValue

        if audios[0]?.fileName == "e54025dddd4e50b320c485e127cadfbc.mp3" {
            return
        }

        var priority: Float = 500
        for player in AudioSession.shareInstance.players {
            if player.category == .music && player.priority > priority {
                priority = player.priority
            }
        }

        if event == 0 {
            audios.values.forEach({ $0.stop() })
            audios.removeAll()
            audios[0] = AudioPlayer(fileName: "e54025dddd4e50b320c485e127cadfbc.mp3", category: .music, loops: 0, completionHandler: {
                self.audios[0] = AudioPlayer(fileName: "c3acd2f9c6fb1fa517ef312b734f3434.mp3", category: .music, loops: -1)!.play()
            })!.play()
        }
        else if event == 1 {
            if audios[12] == nil {
                if audios[1] == nil {
                    audios[1] = AudioPlayer(fileName: "54bdd4852d44925623125395a730e4c4.mp3", category: .music, loops: -1, priority: 600)!.play()
                }
                if audios[1]?.fileName == "54bdd4852d44925623125395a730e4c4.mp3" {
                    cancelStopScroll()
                    perform(#selector(fadeOutScroll), with: nil, afterDelay: 5.0)
                }
            }
        }
        else if event == 2 {
            cancelStopScroll()
            if isStart {
                if audios[1] == nil || audios[1]!.fileName != "f8e5f7be74c1590a5dffc05e8c71445a.mp3" {
                    audios[1]?.stop()
                    audios[1] = AudioPlayer(fileName: "f8e5f7be74c1590a5dffc05e8c71445a.mp3", category: .music, loops: -1, priority: 600)!.play()
                }
            } else {
                if let player = audios[1], player.fileName == "f8e5f7be74c1590a5dffc05e8c71445a.mp3" {
                    audios[1]?.stop()
                    audios[1] = nil
                }
            }
        }
        else if event == 3 {
            if isStart {
                stopScroll()
                audios[3]?.stop()
                audios[3] = AudioPlayer(fileName: "92db5d795d5f9b35bf21f332bf6cf8c5.mp3", category: .music, loops: -1, priority: 600)!.play()
            } else {
                audios[3]?.stop()
                audios[3] = nil
            }
        }
        else if event == 4 {
            if isStart {
                stopScroll()
                audios[3]?.stop()
                audios[3] = AudioPlayer(fileName: "d71ca3981f0762917a7155c146a9d977.mp3", category: .music, loops: -1, priority: 600)!.play()
            } else {
                audios[3]?.stop()
                audios[3] = nil
            }
        }
        else if event == 5 {
            if isStart {
                stopScroll()
                audios[3]?.stop()
                audios[3] = AudioPlayer(fileName: "cf56face53ab4fd8f735980f28fe33cf.mp3", category: .music, loops: -1, priority: 600)!.play()
            } else {
                audios[3]?.stop()
                audios[3] = nil
            }
        }
        else if event == 6 {
            AudioPlayer(fileName: "22637baa230a5fb972f349dd72f4402a.mp3", category: .music, loops: 0, priority: 700)!.play()
        }
        else if event == 7 {
            AudioPlayer(fileName: "20d5ffdfa25f11beb35e601a02d797e3.mp3", category: .music, loops: 0, priority: 600)?.play()
        }
        else if event == 8 {
            AudioPlayer(fileName: "99232405c65c80a5ca941a22d6ddb085.mp3", category: .music, loops: 0, priority: 700)!.play()
        }
        else if event == 9 {
            AudioPlayer(fileName: "c5a4d531c5d8f87cbdc11dc858eff93f.mp3", category: .music, loops: 0, priority: 700)!.play()
        }
        else if event == 10 {
            AudioPlayer(fileName: "f67380dbfa89c98e441657b172aa3467.mp3", category: .music, loops: 0, priority: 700)!.play()
        }
        else if event == 11 {
            if isStart {
                audios[11]?.stop()
                audios[11] = AudioPlayer(fileName: "88512e1a01702df700491632c253e4df.mp3", category: .music, loops: -1, priority: 700)!.play()
            } else {
                audios[11]?.stop()
                audios[11] = nil
            }
        }
        else if event == 21 {
            AudioPlayer(fileName: "c45e1f6ff963245f342040bdaf1e2fae.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 22 {
            AudioPlayer(fileName: "fac6706028cd5d034ef108e4f95e9967.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 23 {
            AudioPlayer(fileName: "3f1d1917eac06beaf362a2d6df375b7c.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 24 {
            if audios[24] == nil {
                audios[24] = AudioPlayer(fileName: "b2de2a13c035932dc0b983dcd0f2e28b.mp3", category: .music, loops: 0, priority: priority, completionHandler: {
                    self.audios[24] = nil
                })!.play()
            }
        }
        else if event == 25 {
            if audios[25] == nil {
                audios[25] = AudioPlayer(fileName: "715bfc1183241d6419146192da438790.mp3", category: .music, loops: 0, priority: priority, completionHandler: {
                    self.audios[25] = nil
                })!.play()
            }
        }
        else if event == 30 {
            AudioPlayer(fileName: "510d51f21c971767075d5efa89d53301.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 31 {
            AudioPlayer(fileName: "25f180f779a773c5e70de8203b02eaf6.mp3", category: .music, loops: 0, priority: 600)!.play()
        }
        else if event == 32 {
            AudioPlayer(fileName: "7af236b6a9b10fb5835944b43e01dc5a.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 37 {
            AudioPlayer(fileName: "9d5df081edadce584e10c8a4dcda383d.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 33 {
            AudioPlayer(fileName: "1f1f81c3d0f2a9eea63eb3aeaa4afb88.mp3", category: .music, loops: 0, priority: 600)!.play()
        }
        else if event == 34 {
            AudioPlayer(fileName: "a164a30e24b09e054109618bd9b82b23.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 35 {
            if data["countDown"].intValue == 3 {
                AudioPlayer(fileName: "ce783321a694c311c6a9b268536c2407.mp3", category: .music, loops: 0, priority: priority)!.play()
            }
        }
        else if event == 36 {
            AudioPlayer(fileName: "931de6f31be0f4e6667adc7067afa566.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 40 {
            AudioPlayer(fileName: "95a3c30c0c3e1ba7108556e4929401fb.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 41 {
            AudioPlayer(fileName: "522c22bb19f6cb8b371d88935fdf94d4.mp3", category: .music, loops: 0, priority: priority)!.play()
        }

    }

    private func cancelStopScroll() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fadeOutScroll), object: nil)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(stopScroll), object: nil)
        audios[1]?.setVolume(audios[1]?.targetVolume ?? 1)
    }

    @objc private func fadeOutScroll() {
        if let player = audios[1] {
            player.setVolume(0, fadeDuration: 1.0)
            perform(#selector(stopScroll), with: nil, afterDelay: 1.0)
        }
    }

    @objc private func stopScroll() {
        audios[1]?.stop()
        audios[1] = nil
    }

}
