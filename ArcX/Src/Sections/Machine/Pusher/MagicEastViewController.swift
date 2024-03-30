//
// Created by LLL on 2024/3/26.
//

import UIKit
import SwiftyJSON

class MagicEastViewController: PusherMachineViewController {

    private var audios: [Int: AudioPlayer] = [:]
    private var eventTimers: [Timer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        audios[0] = AudioPlayer(fileName: "3640098241134e842a7aae0289afb358.mp3", category: .music, loops: -1)!.play()
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

        if audios[0]?.fileName == "50728c2550c7885a7e4519cd4490e5de.mp3" {
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
            audios[0] = AudioPlayer(fileName: "50728c2550c7885a7e4519cd4490e5de.mp3", category: .music, loops: 0, completionHandler: {
                self.audios[0] = AudioPlayer(fileName: "3640098241134e842a7aae0289afb358.mp3", category: .music, loops: -1)!.play()
            })!.play()
        } else if event == 1 {
            if audios[6] == nil {
                if audios[1] == nil {
                    audios[1] = AudioPlayer(fileName: "c44d66aea61b313c2679d936a771f53a.mp3", category: .music, loops: -1, priority: 600)!.play()
                }
                if audios[1]?.fileName == "c44d66aea61b313c2679d936a771f53a.mp3" {
                    cancelStopScroll()
                    perform(#selector(fadeOutScroll), with: nil, afterDelay: 5.0)
                }
            }
        } else if event == 4 {
            cancelStopScroll()
            if isStart {
                if audios[1] == nil || audios[1]!.fileName != "05811d7614325b655b5161e0f2553acf.mp3" {
                    audios[1]?.stop()
                    audios[1] = AudioPlayer(fileName: "05811d7614325b655b5161e0f2553acf.mp3", category: .music, loops: -1, priority: 600)!.play()
                }
            } else {
                if let player = audios[1], player.fileName == "05811d7614325b655b5161e0f2553acf.mp3" {
                    audios[1]?.stop()
                    audios[1] = nil
                }
            }
        }
        else if event == 3 {
            AudioPlayer(fileName: "44391c68c3dd3481ff57a577a0aeeed6.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 4 {
            AudioPlayer(fileName: "9dababe1b6dc23f143703b17d0a89944.mp3", category: .music, loops: 0, priority: priority)!.play()
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
                    self.audios[6] = AudioPlayer(fileName: "84468f7559a509e4714bc6922917d11e.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                        self.audios[6] = AudioPlayer(fileName: "9ed5b8770cfde6aad558712ea6e48c55.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                            self.audios[6] = AudioPlayer(fileName: "80c9cacd17d71e097f937b1cc7c1cb92.mp3", category: .music, loops: -1, priority: 600)!.play()
                        })!.play()
                    })!.play()
                })!.play()
            } else {
                audios[6]?.stop()
                audios[6] = nil
            }
        }
        else if event == 10 {
            AudioPlayer(fileName: "8e687e5aeb71da7eaf6736d8b3080080.mp3", category: .music, loops: 0, priority: 700)!.play()
        }
        else if event == 11 {
            if isStart {
                stopScroll()
                audios[6]?.stop()
                audios[6] = AudioPlayer(fileName: "20d5ffdfa25f11beb35e601a02d797e3.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                    self.audios[6] = AudioPlayer(fileName: "05ffce70724eebd7defb7b2091b25ea6.mp3", category: .music, loops: 0, priority: 600)!.play()
                })!.play()
            } else {
                audios[6]?.stop()
                audios[6] = nil
            }
        }
        else if event == 14 {
            if isStart {
                audios[14]?.stop()
                audios[14] = AudioPlayer(fileName: "8b806204670f1efdb00ffa86274144e2.mp3", category: .music, loops: -1, priority: 700)!.play()
            } else {
                audios[14]?.stop()
                audios[14] = nil
            }
        }
        else if event == 15 {
            AudioPlayer(fileName: "fed6584898fae7608eb75ca4126f8c1c.mp3", category: .music, loops: 0, priority: 700)!.play()
        }
        else if event == 16 {
            AudioPlayer(fileName: "ff7ccd5146684884e79c8b416e990faf.mp3", category: .music, loops: 0, priority: 700)!.play()
        }
        else if event == 17 {
            AudioPlayer(fileName: "a9c239a76e8383c4018d25b74cb362bb.mp3", category: .music, loops: 0, priority: 700)!.play()
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
