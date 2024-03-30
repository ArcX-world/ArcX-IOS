//
// Created by LLL on 2024/3/26.
//

import UIKit
import SwiftyJSON

class KingKongViewController: PusherMachineViewController {

    private var audios: [Int: AudioPlayer] = [:]
    private var eventTimers: [Timer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        audios[0] = AudioPlayer(fileName: "b58dde378612b1b9371d27ff86c43091.mp3", category: .music, loops: -1)!.play()
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

        if audios[0]?.fileName == "23eb4bda84a93569d702ff13973dba30.mp3" {
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
            audios[0] = AudioPlayer(fileName: "23eb4bda84a93569d702ff13973dba30.mp3", category: .music, loops: 0, completionHandler: {
                self.audios[0] = AudioPlayer(fileName: "b58dde378612b1b9371d27ff86c43091.mp3", category: .music, loops: -1)!.play()
            })!.play()
        }
        else if event == 1 {
            if audios[9] == nil {
                if audios[1] == nil {
                    audios[1] = AudioPlayer(fileName: "93b41db50f576c5d5060daaa533a5327.mp3", category: .music, loops: -1, priority: 600)!.play()
                }
                if audios[1]?.fileName == "93b41db50f576c5d5060daaa533a5327.mp3" {
                    cancelStopScroll()
                    perform(#selector(fadeOutScroll), with: nil, afterDelay: 5.0)
                }
            }
        }
        else if event == 4 {
            cancelStopScroll()
            if isStart {
                if audios[1] == nil || audios[1]!.fileName != "08cfad0cf48aadf5681faf5e424330c2.mp3" {
                    audios[1]?.stop()
                    audios[1] = AudioPlayer(fileName: "08cfad0cf48aadf5681faf5e424330c2.mp3", category: .music, loops: -1, priority: 600)!.play()
                }
            } else {
                if let player = audios[1], player.fileName == "08cfad0cf48aadf5681faf5e424330c2.mp3" {
                    audios[1]?.stop()
                    audios[1] = nil
                }
            }
        }
        else if event == 2 {
            AudioPlayer(fileName: "cc33247021e5695f2d98a475617fa63d.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 3 {
            AudioPlayer(fileName: "880588554eef96a7ff3e09b2c6bf341b.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 5 {
            audios[9]?.stop()
            audios[9] = AudioPlayer(fileName: "20d5ffdfa25f11beb35e601a02d797e3.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                self.audios[9] = AudioPlayer(fileName: "9492d261bea535ac1b4f00add4540b67.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                    self.audios[9] = AudioPlayer(fileName: "66e2d0e016ebd9d4aee86ea3268cd685.mp3", category: .music, loops: -1, priority: 600)!.play()
                })!.play()
            })!.play()
        }
        else if event == 6 {
            AudioPlayer(fileName: "38b47e788038bfd3a9fe2c8823b6454f.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 7 {
            AudioPlayer(fileName: "e45d53fa446f20fef3865d68b042800f.mp3", category: .music, loops: 0, priority: priority, completionHandler: {
                AudioPlayer(fileName: "bad436321b2b958993e69f98596015ff.mp3", category: .music, loops: 0, priority: priority)!.play()
            })!.play()
        }
        else if event == 8 {
            AudioPlayer(fileName: "38b47e788038bfd3a9fe2c8823b6454f.mp3", category: .music, loops: 0, priority: priority, completionHandler: {
                AudioPlayer(fileName: "1607544096ea9b80e325242931503ec5.mp3", category: .music, loops: -1, priority: priority)!.play()
            })!.play()
        }
        else if event == 9 {
            stopScroll()
            audios[9]?.stop()
            audios[9] = AudioPlayer(fileName: "20d5ffdfa25f11beb35e601a02d797e3.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                self.audios[9] = AudioPlayer(fileName: "1a672991a672019c92ff41ec65345e6f.mp3", category: .music, loops: -1, priority: 600)!.play()
            })!.play()
        }
        else if event == 10 {
            if !isStart {
                audios[9]?.stop()
                audios[9] = nil
                audios[17]?.stop()
                audios[17] = nil
            }
        }
        else if event == 13 {
            if isStart {
                AudioPlayer(fileName: "sound_ps_link.mp3", category: .music, loops: 0, priority: priority)!.play()
            }
        }
        else if event == 14 {
            AudioPlayer(fileName: "e01b90c9e77ac745bffd2efd03991e0d.mp3", category: .music, loops: 0, priority: 700)!.play()
        }
        else if event == 15 {
            AudioPlayer(fileName: "3ce07efba9829c178775e89f5e28e91f.mp3", category: .music, loops: 0, priority: 700)!.play()
        }
        else if event == 16 {
            AudioPlayer(fileName: "39f3ba382a2b90bb04599426b88d1581.mp3", category: .music, loops: 0, priority: 700)!.play()
        }
        else if event == 17 {
            if isStart {
                AudioPlayer(fileName: "884dc501559bfc6b01a435d8b74806ad.mp3", category: .music, loops: 0, priority: priority)!.play()
            }
        }
        else if event == 20 {
            audios[9]?.stop()
            audios[9] = nil
            if isStart {
                audios[20]?.stop()
                audios[20] = AudioPlayer(fileName: "b6a261e7b0135022c844ed6821faa19d.mp3", category: .music, loops: -1, priority: 700)!.play()
            } else {
                audios[20]?.stop()
                audios[20] = nil
            }
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
