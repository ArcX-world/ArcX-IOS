//
// Created by LLL on 2024/3/14.
//

import UIKit
import SwiftyJSON

class MachineBasedViewController: BaseViewController {

    var machineDetails: MachineDetails!

    var mode: Mode! {
        didSet { if mode != oldValue { layoutSubviews() } }
    }

    var duration: Int { return 60 }
    var ignoreCodes: [Int] = [ 1030 ]
    var CMD_C2S_DEFAULT: Int = 0
    var CMD_S2C_DEFAULT: Int = 0
    var gameTimer: Timer?

    weak var playView: SmartPlayView!
    weak var startProgressHUD: ProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()
        join()

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed || navigationController == nil {
            destroy()
        }
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [ .portrait, .landscape ]
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }


    // MARK: - Public


    func startGame(with parameter: [String: Any] = [:]) {
        startProgressHUD = ProgressHUD.showHUD(addedTo: view)
        send(signal: SocketSignal.START_GAME, parameter: parameter)
        perform(#selector(startDidTimeout), with: nil, afterDelay: 10)
    }

    @objc func startDidTimeout() {
        startProgressHUD?.hide()
    }

    func quitGame() {
        stopTimer()
        if mode == .player {
            send(signal: SocketSignal.QUIT_GAME)
        }
        mode = .guest
    }

    func join() {
        if let player = machineDetails.gmPly {
            mode = player.plyId == AccessToken.current?.userId ? .player : .viewer
        } else {
            mode = .guest
        }

        send(cmd: SocketCMD.C2S.MCH_JOIN)
        send(cmd: SocketCMD.C2S.MCH_INFO)
        send(cmd: SocketCMD.C2S.TOKEN_BALANCE)
        if mode == .player {
            send(cmd: SocketCMD.C2S.MCH_REFRESH)
        }
    }

    func send(cmd: Int, parameter: [String: Any]? = nil) {
        var parameter = parameter ?? [:]
        parameter["devId"] = machineDetails.devId
        WebSocket.client.send(string: SocketPacket(cmd: cmd, parameter: parameter))
    }

    func send(signal: Int, parameter: [String: Any]? = nil) {
        var parameter = parameter ?? [:]
        parameter["hdlTp"] = signal
        send(cmd: CMD_C2S_DEFAULT, parameter: parameter)
    }

    func startTimer(_ seconds: Int) {
        gameTimer?.invalidate()
        var _seconds = seconds
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if _seconds > 0 {
                _seconds -= 1
                self.onTickTack(_seconds)
            } else {
                timer.invalidate()
            }
        }
        gameTimer?.fire()
    }

    func stopTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }

    func onTickTack(_ seconds: Int) {
        logger.info("\(seconds)s")
    }

    func destroy() {
        logger.info()
        NotificationCenter.default.removeObserver(self)
        stopTimer()
        if mode == .player {
            send(signal: SocketSignal.QUIT_GAME)
        }
        send(cmd: SocketCMD.C2S.MCH_LEAVE)
    }

    func prepareForStart() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(startDidTimeout), object: nil)
        startProgressHUD?.hide()
        mode = .player
        startTimer(duration)
        send(cmd: SocketCMD.C2S.MCH_REFRESH)
    }


    func webSocket(_ webSocket: WebSocket, didReceiveJson json: JSON) {
        let cmd = json["cmd"].intValue
        let errorCode = json["param"]["errorCode"].intValue
        let data = json["param"]["serverMsg"]
        if errorCode == 1 {
            if cmd == CMD_S2C_DEFAULT {
                if data["hdlTp"].int == SocketSignal.START_GAME {
                    prepareForStart()
                }
                else if data["hdlTp"].int == SocketSignal.QUIT_GAME {
                    stopTimer()
                    mode = .guest
                }
            }
            else if cmd == SocketCMD.S2C.MCH_INFO {
                if data["devId"].intValue == machineDetails.devId {
                    machineDetails.gmPly = MachinePlayer.from(json: data["gmPly"].dictionaryObject)
                    if let player = machineDetails.gmPly {
                        mode = player.plyId == AccessToken.current?.userId ? .player : .viewer
                    } else {
                        mode = .guest
                    }
                }
            }
            else if cmd == SocketCMD.S2C.MCH_REFRESH {
                startTimer(data["lfTm"].intValue)
            }
            else if cmd == SocketCMD.S2C.MCH_KICK_OUT {
                presentingViewController?.dismiss(animated: true)
            }
        } else {
            if data["hdlTp"].int == SocketSignal.START_GAME || errorCode == 1020 || errorCode == 1030 {
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(startDidTimeout), object: nil)
                startProgressHUD?.hide()
            }
            if let errorDesc = json["param"]["errorDesc"].string {
                if !ignoreCodes.contains(errorCode) {
                    ToastView.showToast(errorDesc, in: view)
                }
            }
            if errorCode == 1030 {
//                let alertController = MachineAlertController(title: "", content: "")
//                alertController.contentLabel.attributedText = NSAttributedString(string: "\n" + "余额不足", attributes: [ .font: UIFont.systemFont(ofSize: 24, weight: .heavy) ])
//                alertController.addAction(AlertAction(title: "取消", handler: nil))
//                alertController.addAction(AlertAction(title: "充值") { _ in
//                    self.present(MachineRechargeViewController(), animated: true)
//                })
//                present(alertController, animated: true)
            }
        }
    }

    func layoutSubviews() {
        logger.info("Mode: \(mode)")
        view.backgroundColor = .clear
        view.subviews.forEach({ $0.removeFromSuperview() })
    }

}


extension MachineBasedViewController {

    enum Mode {
        case player
        case viewer
        case guest
    }

}