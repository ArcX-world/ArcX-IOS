//
// Created by LLL on 2024/3/26.
//

import UIKit
import SwiftyJSON

class JokerCircusViewController: PusherMachineViewController {

    private var audios: [Int: AudioPlayer] = [:]
    private var eventTimers: [Timer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        audios[0] = AudioPlayer(fileName: "6c0de8c7ed0e92152c82907805efd830.mp3", category: .music, loops: -1)!.play()
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

        if audios[0]?.fileName == "96f1ed7ad3cf1cade32f78c40dbb46e9.mp3" {
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
            audios[0] = AudioPlayer(fileName: "96f1ed7ad3cf1cade32f78c40dbb46e9.mp3", category: .music, loops: 0, completionHandler: {
                self.audios[0] = AudioPlayer(fileName: "6c0de8c7ed0e92152c82907805efd830.mp3", category: .music, loops: -1)!.play()
            })!.play()
        }
        else if event == 22 {
            if audios[12] == nil {
                if audios[1] == nil {
                    audios[1] = AudioPlayer(fileName: "2e108557c3235c96f20a1bd24dccb92a.mp3", category: .music, loops: -1, priority: 600)!.play()
                }
                if audios[1]?.fileName == "2e108557c3235c96f20a1bd24dccb92a.mp3" {
                    cancelStopScroll()
                    perform(#selector(fadeOutScroll), with: nil, afterDelay: 5.0)
                }
            }
        }
        else if event == 2 {
            cancelStopScroll()
            if isStart {
                if audios[1] == nil || audios[1]!.fileName != "8783c4d05b0d825e6484ba2f0d1c6835.mp3" {
                    audios[1]?.stop()
                    audios[1] = AudioPlayer(fileName: "8783c4d05b0d825e6484ba2f0d1c6835.mp3", category: .music, loops: -1, priority: 600)!.play()
                }
            } else {
                if let player = audios[1], player.fileName == "8783c4d05b0d825e6484ba2f0d1c6835.mp3" {
                    audios[1]?.stop()
                    audios[1] = nil
                }
            }
        }
        else if event == 4 {
            if isStart {
                AudioPlayer(fileName: "sound_ps_link.mp3", category: .music, loops: 0, priority: priority)!.play()
            }
        }
        else if event == 8 {
            AudioPlayer(fileName: "e927c96dd66fd32e3031cd1f0358c9ad.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 9 {
            AudioPlayer(fileName: "e207d939a1441720ea066ee7f5fa1216.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 10 {
            AudioPlayer(fileName: "e3ac1b7621971f93497b12de7175e4dd.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 11 {
            if isStart {
                audios[11]?.stop()
                audios[11] = AudioPlayer(fileName: "08efe9c63e7b101476f14112960e82ed.mp3", category: .music, loops: -1, priority: 600)!.play()
            } else {
                audios[11]?.stop()
                audios[11] = nil
            }
        }
        else if event == 12 {
            if isStart {
                stopScroll()
                audios[12]?.stop()
                audios[12] = AudioPlayer(fileName: "20d5ffdfa25f11beb35e601a02d797e3.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                    self.audios[12] = AudioPlayer(fileName: "a112e225871597079ce4cd04aa5b16ad.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                        self.audios[12] = AudioPlayer(fileName: "9a1d55bc1f724f00d73c219c959ff118.mp3", category: .music, loops: -1, priority: 600)!.play()
                    })!.play()
                })!.play()
            } else {
                audios[12]?.stop()
                audios[12] = nil
            }
        }
        else if event == 13 {
            if isStart {
                stopScroll()
                audios[12]?.stop()
                audios[12] = AudioPlayer(fileName: "20d5ffdfa25f11beb35e601a02d797e3.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                    self.audios[12] = AudioPlayer(fileName: "858c778824619826f0400d4315dfe1ab.mp3", category: .music, loops: -1, priority: 600)!.play()
                })!.play()
            } else {
                audios[12]?.stop()
                audios[12] = nil
            }
        }
        else if event == 14 {
            if isStart {
                stopScroll()
                audios[12]?.stop()
                audios[12] = AudioPlayer(fileName: "20d5ffdfa25f11beb35e601a02d797e3.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                    self.audios[12] = AudioPlayer(fileName: "f8b6d61044c2d920e3a22aef38a3fa2d.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                        self.audios[12] = AudioPlayer(fileName: "b03c55746538b666799e26da8dea2d69.mp3", category: .music, loops: -1, priority: 600)!.play()
                    })!.play()
                })!.play()
            } else {
                audios[12]?.stop()
                audios[12] = nil
            }
        }
        else if event == 15 {
            if isStart {
                let type = data["AnimalType"].intValue
                AudioPlayer(fileName: "8066a376213e1f0e8d2760f30004d4af.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                    AudioPlayer(fileName: "c994620799daf45d00180599bcd61789.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                        if type == 1 {
                            AudioPlayer(fileName: "0c76170cc629fd1d8067aade67406d87.mp3", category: .music, loops: 0, priority: 600)?.play()
                        } else if type == 2 {
                            AudioPlayer(fileName: "09064e277005d28992122a33ae90b039.mp3", category: .music, loops: 0, priority: 600)?.play()
                        } else if type == 3 {
                            AudioPlayer(fileName: "91d8a7d587b5e2d5e412dfd16866299e.mp3", category: .music, loops: 0, priority: 600)?.play()
                        } else if type == 4 {
                            AudioPlayer(fileName: "56d1a0c2369eb6ba2e222d68d9795b6e.mp3", category: .music, loops: 0, priority: 600)?.play()
                        } else if type == 5 {
                            AudioPlayer(fileName: "bc016ac3c275f99df251fd0883613936.mp3", category: .music, loops: 0, priority: 600)?.play()
                        } else if type == 6 {
                            AudioPlayer(fileName: "fb39901838aab55bcd90f631d8818be1.mp3", category: .music, loops: 0, priority: 600)?.play()
                        }
                    })!.play()
                })!.play()
            }
        }
        else if event == 16 {
            if isStart {
                AudioPlayer(fileName: "8066a376213e1f0e8d2760f30004d4af.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                    AudioPlayer(fileName: "27c47b08a631f174293918c5ef3f945b.mp3", category: .music, loops: 0, priority: 600)!.play()
                })!.play()
            }
        }
        else if event == 18 {
            AudioPlayer(fileName: "375df4bf1b2bc28155de3f10e5fdb626.mp3", category: .music, loops: 0, priority: 600)!.play()
        }
        else if event == 19 {
            AudioPlayer(fileName: "6117a32987185f269c7e48f2eda20f62.mp3", category: .music, loops: 0, priority: 600)!.play()
        }
        else if event == 20 {
            if isStart {
                audios[20]?.stop()
                audios[20] = AudioPlayer(fileName: "1556d953de72e24c9661dbd981fcd48c.mp3", category: .music, loops: -1, priority: 600)!.play()
            } else {
                audios[20]?.stop()
                audios[20] = nil
            }
        }
        else if event == 21 {
            AudioPlayer(fileName: "a22a908d844825cd6b50247114f67d1c.mp3", category: .music, loops: 0, priority: 600)!.play()
        }
        else if event == 24 {
            let count = data["clownCircusResetTime"].intValue
            if count == 1 {
                AudioPlayer(fileName: "f264846f9e4c92296fe78d9214b7405f.mp3", category: .music, loops: 0, priority: priority)!.play()
            } else if count == 2 {
                AudioPlayer(fileName: "663b03a8a842deae99cb6491fa93abe1.mp3", category: .music, loops: 0, priority: priority)!.play()
            } else if count == 3 {
                AudioPlayer(fileName: "7dd806ec093b570a2cd1e164bddb5a99.mp3", category: .music, loops: 0, priority: priority)!.play()
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
