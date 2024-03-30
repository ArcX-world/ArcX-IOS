//
// Created by LLL on 2024/3/26.
//

import UIKit
import SwiftyJSON

class EgyptianViewController: PusherMachineViewController {

    private var audios: [Int: AudioPlayer] = [:]
    private var eventTimers: [Timer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        audios[0] = AudioPlayer(fileName: "6eb66d592e7f339e366c32edbc3a9738.mp3", category: .music, loops: -1)!.play()
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

        if audios[0]?.fileName == "7d7fbc069fc1cb62a8a8a947c3bdc6f0.mp3" {
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
            audios[0] = AudioPlayer(fileName: "7d7fbc069fc1cb62a8a8a947c3bdc6f0.mp3", category: .music, loops: 0, completionHandler: {
                self.audios[0] = AudioPlayer(fileName: "6eb66d592e7f339e366c32edbc3a9738.mp3", category: .music, loops: -1)!.play()
            })!.play()
        }
        else if event == 1 {
            if audios[12] == nil {
                if audios[1] == nil {
                    audios[1] = AudioPlayer(fileName: "43876a7e51a8a620868d36dd498696fe.mp3", category: .music, loops: -1, priority: 600)!.play()
                }
                if audios[1]?.fileName == "43876a7e51a8a620868d36dd498696fe.mp3" {
                    cancelStopScroll()
                    perform(#selector(fadeOutScroll), with: nil, afterDelay: 5.0)
                }
            }
        }
        else if event == 4 {
            cancelStopScroll()
            if isStart {
                if audios[1] == nil || audios[1]!.fileName != "43850bd9ac91942b7b9c745f6c27c227.mp3" {
                    audios[1]?.stop()
                    audios[1] = AudioPlayer(fileName: "43850bd9ac91942b7b9c745f6c27c227.mp3", category: .music, loops: -1, priority: 600)!.play()
                }
            } else {
                if let player = audios[1], player.fileName == "43850bd9ac91942b7b9c745f6c27c227.mp3" {
                    audios[1]?.stop()
                    audios[1] = nil
                }
            }
        }
        else if event == 2 {
            AudioPlayer(fileName: "86be28ff3c25993921cc7a1439c82406.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 3 {
            AudioPlayer(fileName: "89741a5d9799135e801464c9fb3abbdc.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 5 {
            stopScroll()
            audios[12]?.stop()
            audios[12] = AudioPlayer(fileName: "20d5ffdfa25f11beb35e601a02d797e3.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                self.audios[12] = AudioPlayer(fileName: "c246d4bfec742ee642cf31893fefb572.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                    self.audios[12] = AudioPlayer(fileName: "4a536f5dc93845fcecd8cec992e573cb.mp3", category: .music, loops: -1, priority: 600)!.play()
                })!.play()
            })!.play()
        }
        else if event == 6 {
            AudioPlayer(fileName: "665ee4f4d60f55cd68ef44aad6f83bb9.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 7 {
            AudioPlayer(fileName: "7283030f3b12a8da76561e3ad6f32faa.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 8 {
            let jackPotType = data["jackPotType"].intValue
            if jackPotType == 1 {
                AudioPlayer(fileName: "9ed87b8aec3104a0bc5d682965e5ab55.mp3", category: .music, loops: 0, priority: priority)!.play()
            } else if jackPotType == 2 {
                AudioPlayer(fileName: "d4c39769b97cae63f670aeb6f271471f.mp3", category: .music, loops: 0, priority: priority)!.play()
            } else if jackPotType == 3 {
                AudioPlayer(fileName: "b31da05872785e14c7216ff879214f1e.mp3", category: .music, loops: 0, priority: priority)!.play()
            }
        }
        else if event == 9 {
            AudioPlayer(fileName: "fbbb7a6157fb075bc83201a52f086e89.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 10 {
            if data["countDown"].int == 3 {
                AudioPlayer(fileName: "e99a55437d262e866e4ca6b89aad99ab.mp3", category: .music, loops: 0, priority: priority)!.play()
            }
        }
        else if event == 11 {
            audios[12]?.stop()
            audios[12] = nil
            AudioPlayer(fileName: "94c1bef15b1333a19d80d5ad5170a95e.mp3", category: .music, loops: 0, priority: priority)!.play()
        }
        else if event == 12 {
            stopScroll()
            audios[12]?.stop()
            audios[12] = AudioPlayer(fileName: "20d5ffdfa25f11beb35e601a02d797e3.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                self.audios[12] = AudioPlayer(fileName: "0084e83a0c11c873ed16cff70e9d6afe.mp3", category: .music, loops: 0, priority: 600, completionHandler: {
                    self.audios[12] = AudioPlayer(fileName: "d9ba573b39dc3c7566060c1fbe804a9c.mp3", category: .music, loops: -1, priority: 600)!.play()
                })!.play()
            })!.play()
        }
        else if event == 14 {
            if isStart {
                AudioPlayer(fileName: "sound_ps_link.mp3", category: .music, loops: 0, priority: priority)!.play()
            }
        }
        else if event == 15 {
            AudioPlayer(fileName: "e01b90c9e77ac745bffd2efd03991e0d.mp3", category: .music, loops: 0, priority: 700)!.play()
        }
        else if event == 16 {
            AudioPlayer(fileName: "3ce07efba9829c178775e89f5e28e91f.mp3", category: .music, loops: 0, priority: 700)!.play()
        }
        else if event == 17 {
            AudioPlayer(fileName: "39f3ba382a2b90bb04599426b88d1581.mp3", category: .music, loops: 0, priority: 700)!.play()
        }
        else if event == 20 {
            if isStart {
                audios[20]?.stop()
                audios[20] = AudioPlayer(fileName: "386bd4428a099c10de928a5bf6c3887c.mp3", category: .music, loops: -1, priority: 700)!.play()
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
