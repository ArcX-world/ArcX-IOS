//
// Created by LLL on 2024/3/26.
//

import UIKit
import SwiftyJSON

class ThunderViewController: PusherMachineViewController {

    private var audios: [Int: AudioPlayer] = [:]
    private var eventTimers: [Timer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        audios[0] = AudioPlayer(fileName: "3ca1b3426def0ce80ead53999b3faf41.mp3", category: .music, loops: -1)!.play()
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
        let errorCode = json["param"]["errorCode"].intValue
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

        if audios[0]?.fileName == "b05c4e6596cf7106e583270eb21584ee.mp3" {
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
            audios[0] = AudioPlayer(fileName: "b05c4e6596cf7106e583270eb21584ee.mp3", category: .music, loops: 0, completionHandler: {
                self.audios[0] = AudioPlayer(fileName: "3ca1b3426def0ce80ead53999b3faf41.mp3", category: .music, loops: -1)!.play()
            })!.play()
        }
        else if event == 1 {
            if audios[6] == nil {
                if audios[1] == nil {
                    audios[1] = AudioPlayer(fileName: "47920c50641fc790979e4088985a5f85.mp3", category: .music, loops: -1, priority: 600)!.play()
                }
                if audios[1]?.fileName == "47920c50641fc790979e4088985a5f85.mp3" {
                    cancelStopScroll()
                    perform(#selector(fadeOutScroll), with: nil, afterDelay: 5.0)
                }
            }
        }
        else if event == 2 {
            cancelStopScroll()
            if isStart {
                if audios[1] == nil || audios[1]!.fileName != "7c5fa1b35952ff761d27b06c786f455d.mp3" {
                    audios[1]?.stop()
                    audios[1] = AudioPlayer(fileName: "7c5fa1b35952ff761d27b06c786f455d.mp3", category: .music, loops: -1, priority: 600)!.play()
                }
            } else {
                if let player = audios[1], player.fileName == "7c5fa1b35952ff761d27b06c786f455d.mp3" {
                    audios[1]?.stop()
                    audios[1] = nil
                }
            }
        }
        else if event == 3 {
            AudioPlayer(fileName: "62b65255603d07079333bf98562550f1.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 4 {
            AudioPlayer(fileName: "a365d67e790c7f6d61b38734dcfe1e6e.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 5 {
            if isStart {
                AudioPlayer(fileName: "sound_ps_link.mp3", category: .music, loops: 0, priority: priority)!.play()
            }
        }
        else if event == 6 {
            if isStart {
                stopScroll()
                audios[6]?.stop()
                audios[6] = AudioPlayer(fileName: "20d5ffdfa25f11beb35e601a02d797e3.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                    self.audios[9] = AudioPlayer(fileName: "091294e695db31453a1201d144a8848a.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                        self.audios[9] = AudioPlayer(fileName: "3419e58ee4acecb27a011de366e4da81.mp3", category: .music, loops: -1, priority: 600)!.play()
                    })!.play()
                })!.play()
            } else {
                audios[6]?.stop()
                audios[6] = nil
            }
        }
        else if event == 7 {
            if isStart {
                stopScroll()
                audios[6]?.stop()
                audios[6] = AudioPlayer(fileName: "20d5ffdfa25f11beb35e601a02d797e3.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                    self.audios[9] = AudioPlayer(fileName: "468ac8f0549f1cfca7eccd674d086054.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                        self.audios[9] = AudioPlayer(fileName: "e346ed0b072be65635ecdb2ecc21bbc5.mp3", category: .music, loops: -1, priority: 600)!.play()
                    })!.play()
                })!.play()
            } else {
                audios[6]?.stop()
                audios[6] = nil
            }
        }
        else if event == 13 {
            AudioPlayer(fileName: "c96a3e6faab999c77d322e9584108d6b.mp3", category: .music, loops: 0, priority: priority)?.play()
        }
        else if event == 14 {
            if isStart {
                audios[14]?.stop()
                audios[14] = AudioPlayer(fileName: "446cbe0d9a73096a55b38898c5c343ef.mp3", category: .music, loops: -1, priority: 700)!.play()
            } else {
                audios[14]?.stop()
                audios[14] = nil
            }
        }
        else if event == 15 {
            AudioPlayer(fileName: "93940c53dd33d6d987d38f42b3ae7098.mp3", category: .music, loops: 0, priority: priority)?.play()
        }
        else if event == 16 {
            AudioPlayer(fileName: "c5487b8845f1c51db2ad5d596a06fa55.mp3", category: .music, loops: 0, priority: priority)?.play()
        }
        else if event == 17 {
            AudioPlayer(fileName: "2f9810914c9930c922adae3c1156688a.mp3", category: .music, loops: 0, priority: priority)?.play()
        }
        else if event == 18 {
            AudioPlayer(fileName: "379420a101c6ff7250497ea3335cb7c9.mp3", category: .music, loops: 0, priority: priority)?.play()
        }
        else if event == 19 {
            AudioPlayer(fileName: "6d90a9dbf24d4a45c4082ccbd110796d.mp3", category: .music, loops: 0, priority: priority)?.play()
        }
        else if event == 20 {
            AudioPlayer(fileName: "502c33756ff7c8f93279af887887411a.mp3", category: .music, loops: 0, priority: priority)?.play()
        }
        else if event == 21 {
            AudioPlayer(fileName: "967776018d7756bc51d789451ceba2b0.mp3", category: .music, loops: 0, priority: 600)?.play()
        }
        else if event == 23 {
            AudioPlayer(fileName: "62b65255603d07079333bf98562550f1.mp3", category: .music, loops: 0, priority: 600)?.play()
        }
        else if event == 24 {
            AudioPlayer(fileName: "b0f7d1c278ebc9366797260dd6bed7fe.mp3", category: .music, loops: 0, priority: 600)?.play()
        }
        else if event == 25 {
            AudioPlayer(fileName: "1d3143032e88dbf089cc91981e10382e.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                AudioPlayer(fileName: "b0f7d1c278ebc9366797260dd6bed7fe.mp3", category: .music, loops: 0, priority: 600)?.play()
            })?.play()
        }
        else if event == 26 {
            AudioPlayer(fileName: "71274e3b709f6f0eceb7eae23bd17ef8.mp3", category: .music, loops: 0, priority: 600)?.play()
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
