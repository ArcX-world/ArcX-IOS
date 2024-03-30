//
// Created by LLL on 2024/3/16.
//

import UIKit
import SwiftyJSON
import SVGAPlayer

class ClawMachineViewController: MachineBasedViewController {


    private let avatarView = UIImageView()
    private let gameTokenView = TokenBalanceView(hasPlus: true)
    private let axcTokenView = TokenBalanceView(hasPlus: true)
    private let viewerStackView = MachineViewerStackView()
    private let toolbar = MachineToolbar()
    private let energyView = EnergyProgressView(frame: CGRect())
    private let upButton = MachineButton(frame: CGRect(x: 0, y: 0, width: 54, height: 54))
    private let leftButton = MachineButton(frame: CGRect(x: 0, y: 0, width: 54, height: 54))
    private let downButton = MachineButton(frame: CGRect(x: 0, y: 0, width: 54, height: 54))
    private let rightButton = MachineButton(frame: CGRect(x: 0, y: 0, width: 54, height: 54))
    private let catchButton = MachineButton(frame: CGRect(x: 0, y: 0, width: 54, height: 54))
    private let secondsLabel = UILabel(text: nil, textColor: .white, fontSize: 14, weight: .medium)


    override func viewDidLoad() {
        CMD_C2S_DEFAULT = 2003
        CMD_S2C_DEFAULT = 2004
        super.viewDidLoad()
        commonInit()
    }

    override var duration: Int {
        return 30
    }

    override func join() {
        super.join()
        send(cmd: SocketCMD.C2S.USER_ENERGY)
    }

    override func onTickTack(_ seconds: Int) {
        super.onTickTack(seconds)
        secondsLabel.text = "\(seconds)"
        if seconds == 0 {
            send(signal: SocketSignal.CATCH)
        }
    }

    override func send(signal: Int, parameter: [String: Any]? = nil) {
        super.send(signal: signal, parameter: parameter)
        if signal == SocketSignal.CATCH {
            [ upButton, leftButton, downButton, rightButton, catchButton ].forEach({ $0.isEnabled = false })
            stopTimer()
            secondsLabel.text = nil
        }
    }

    override func webSocket(_ webSocket: WebSocket, didReceiveJson json: JSON) {
        super.webSocket(webSocket, didReceiveJson: json)
        let cmd = json["cmd"].intValue
        let data = json["param"]["serverMsg"]
        let errorCode = json["param"]["errorCode"].intValue

        if errorCode == 1 {
            if cmd == CMD_S2C_DEFAULT {
                if data["hdlTp"].int == 11 {
                    let bonusItems = Array<BonusItem>.from(json: data["awdTbln"].arrayObject) ?? []
                    let bonusViewController = MachineBonusViewController(bonusItems: bonusItems)
                    bonusViewController.onCancel = { [weak self] in
                        self?.quitGame()
                    }
                    bonusViewController.onPlay = { [weak self] in
                        self?.startGame()
                    }
                    present(bonusViewController, animated: true)
                }
                else if data["hdlTp"].int == SocketSignal.PUSH {
                    startTimer(duration)
                }
            }
            else if cmd == SocketCMD.S2C.TOKEN_BALANCE {
                gameTokenView.value = data["gdAmt"].number
                axcTokenView.value = data["axcAmt"].number
            }
            else if cmd == SocketCMD.S2C.USER_ENERGY {
                let val = data["cnAmt"].intValue
                let total = data["ttAmt"].intValue
                energyView.setProgress(val, maximum: total)
            }
            else if cmd == SocketCMD.S2C.MCH_INFO {
                if data["vsUsrTbln"].arrayValue.count != viewerStackView.dataSource.count {
                    if let array = Array<MachinePlayer>.from(json: data["vsUsrTbln"].arrayObject) {
                        viewerStackView.dataSource = array
                    }
                }
            }
        }
    }

    // MARK: - Private

    @objc private func quitButtonClick() {
        presentingViewController?.dismiss(animated: true)
    }

    @objc private func voiceButtonClick() {
        toolbar.setVoiceOn(!toolbar.isVoiceOn)
        AudioSession.shareInstance.setActive(toolbar.isVoiceOn, with: .default)
        AudioSession.shareInstance.setActive(toolbar.isVoiceOn, with: .music)
    }

    @objc private func repairButtonClick() {
        let title = NSMutableAttributedString(string: "\n是否报修？\n报修后将通知管理人员")
        title.insert(NSAttributedString(attachment: NSTextAttachment(image: UIImage(named: "img_mch_repair")!, bounds: CGRect(x: 0, y: 10, width: 52, height: 52))), at: 0)
        let alertController = MachineAlertController(title: "", content: nil)
        alertController.titleLabel.attributedText = title
        alertController.addAction(AlertAction(title: "No"))
        alertController.addAction(AlertAction(title: "Call") { _ in
            // TODO
        })
        present(alertController, animated: true)
    }

    @objc private func playButtonClick() {
        ensureAuth {
            startGame()
        }
    }

    override func prepareForStart() {
        super.prepareForStart()
        [ upButton, leftButton, downButton, rightButton, catchButton ].forEach({ $0.isEnabled = true })

        let animatedView = SVGAPlayer()
        animatedView.loops = 1
        animatedView.clearsAfterStop = true
        view.addSubview(animatedView)
        animatedView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 375, height: 166))
        }

        SVGAParser().parse(withNamed: "ani_mch_start", in: nil) { (videoItem: SVGAVideoEntity) in
            animatedView.videoItem = videoItem
            animatedView.startAnimation()

            DispatchQueue.main.asyncAfter(deadline: .now() + videoItem.duration) {
                animatedView.removeFromSuperview()
            }
        }
    }

    private func commonInit() {
        avatarView.layer.borderWidth = 1.0
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.layer.cornerRadius = 28
        avatarView.layer.masksToBounds = true
        avatarView.backgroundColor = UIColor(hex: 0xEEEEEE)

        axcTokenView.icon = UIImage(named: "img_axc_token")

        toolbar.setVoiceOn(AudioSession.shareInstance.active(with: .default))
        toolbar.items = [ toolbar.quitButton, toolbar.voiceButton, toolbar.repairButton ]
        toolbar.quitButton.addTarget(self, action: #selector(quitButtonClick), for: .touchUpInside)
        toolbar.voiceButton.addTarget(self, action: #selector(voiceButtonClick), for: .touchUpInside)
        toolbar.repairButton.addTarget(self, action: #selector(repairButtonClick), for: .touchUpInside)

        upButton.setImage(UIImage(named: "img_mch_claw_move_01"), for: .normal)
        upButton.add(listener: MachineButton.TouchDownListener(interval: 0) { [weak self] in
            self?.send(signal: SocketSignal.MOVE_UP)
        })
        upButton.add(listener: MachineButton.TouchUpListener { [weak self] in
            self?.send(signal: SocketSignal.STOP_MOVE)
        })

        leftButton.setImage(UIImage(named: "img_mch_claw_move_02"), for: .normal)
        leftButton.add(listener: MachineButton.TouchDownListener(interval: 0) { [weak self] in
            self?.send(signal: SocketSignal.MOVE_LEFT)
        })
        leftButton.add(listener: MachineButton.TouchUpListener { [weak self] in
            self?.send(signal: SocketSignal.STOP_MOVE)
        })

        downButton.setImage(UIImage(named: "img_mch_claw_move_03"), for: .normal)
        downButton.add(listener: MachineButton.TouchDownListener(interval: 0) { [weak self] in
            self?.send(signal: SocketSignal.MOVE_DOWN)
        })
        downButton.add(listener: MachineButton.TouchUpListener { [weak self] in
            self?.send(signal: SocketSignal.STOP_MOVE)
        })

        rightButton.setImage(UIImage(named: "img_mch_claw_move_04"), for: .normal)
        rightButton.add(listener: MachineButton.TouchDownListener(interval: 0) { [weak self] in
            self?.send(signal: SocketSignal.MOVE_RIGHT)
        })
        rightButton.add(listener: MachineButton.TouchUpListener { [weak self] in
            self?.send(signal: SocketSignal.STOP_MOVE)
        })

        catchButton.setBackgroundImage(UIImage(named: "img_mch_claw_catch"), for: .normal)
        catchButton.add(listener: MachineButton.TouchDownListener(interval: 0) { [weak self] in
            self?.send(signal: SocketSignal.CATCH)
        })

        secondsLabel.font = UIFont(name: "qiantuhouheiti", size: 20)

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        playView.superview?.layer.contents = UIImage.gradient(colors: [ UIColor(hex: 0x6973E1), UIColor(hex: 0x886AF0) ], size: view.bounds.size, start: CGPoint(), end: CGPoint(x: 0, y: 1)).cgImage
        playView.snp.remakeConstraints { make in
            make.top.equalTo(playView.superview!.snp.topMargin).offset(44 + 24)
            make.left.right.equalToSuperview()
            make.height.equalTo(view.frame.width * 1.36)
        }

        if let player = machineDetails.gmPly {
            avatarView.kf.setImage(with: URL(string: player.plyPct))
        } else if let profile = Profile.current {
            avatarView.kf.setImage(with: URL(string: profile.plyPct))
        }

        view.addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(2)
            make.left.equalTo(10)
            make.size.equalTo(56)
        }

        view.addSubview(gameTokenView)
        gameTokenView.snp.makeConstraints { make in
            make.centerY.equalTo(avatarView)
            make.left.equalTo(avatarView.snp.right).offset(6)
            make.width.equalTo((view.frame.width - 196) * 0.55)
        }

        view.addSubview(axcTokenView)
        axcTokenView.snp.makeConstraints { make in
            make.centerY.equalTo(gameTokenView)
            make.left.equalTo(gameTokenView.snp.right).offset(6)
            make.width.equalTo((view.frame.width - 196) * 0.45)
        }

        view.addSubview(viewerStackView)
        viewerStackView.snp.makeConstraints { make in
            make.left.equalTo(axcTokenView.snp.right).offset(6)
            make.centerY.equalTo(axcTokenView)
        }

        toolbar.setSwitchOn(false)
        view.addSubview(toolbar)
        toolbar.snp.makeConstraints { make in
            make.centerY.equalTo(avatarView)
            make.right.equalTo(-10)
        }

        if mode == .player {
            gameTokenView.isHidden = false
            axcTokenView.isHidden = false

            view.addSubview(energyView)
            energyView.snp.makeConstraints { make in
                make.top.equalTo(avatarView.snp.bottom).offset(12)
                make.left.equalTo(4)
                make.width.equalTo(98)
            }

            let moveView = UIView()
            view.addSubview(moveView)
            moveView.snp.makeConstraints { make in
                make.left.equalTo(30)
                make.bottom.equalTo(view.snp.bottomMargin).offset(-40)
                make.size.equalTo(CGSize(width: 162, height: 140))
            }

            moveView.addSubview(upButton)
            upButton.snp.makeConstraints { make in
                make.top.centerX.equalToSuperview()
            }

            moveView.addSubview(leftButton)
            leftButton.snp.makeConstraints { make in
                make.left.centerY.equalToSuperview()
            }

            moveView.addSubview(downButton)
            downButton.snp.makeConstraints { make in
                make.bottom.centerX.equalToSuperview()
            }

            moveView.addSubview(rightButton)
            rightButton.snp.makeConstraints { make in
                make.right.centerY.equalToSuperview()
            }

            view.addSubview(catchButton)
            catchButton.snp.makeConstraints { make in
                make.centerY.equalTo(moveView)
                make.right.equalTo(-30)
            }

            view.addSubview(secondsLabel)
            secondsLabel.snp.makeConstraints { make in
                make.top.equalTo(catchButton.snp.bottom).offset(3)
                make.centerX.equalTo(catchButton)
            }

        }
        else if mode == .viewer {
            gameTokenView.isHidden = true
            axcTokenView.isHidden = true
        }
        else if mode == .guest {
            gameTokenView.isHidden = false
            axcTokenView.isHidden = false

            let playButton = UIButton.plain(title: "", fontSize: 16, weight: .bold)
            playButton.contentEdgeInsets = UIEdgeInsets(top: 11, left: 0, bottom: -11, right: 0)
            playButton.setImage(UIImage(named: "img_game_token")?.resizeImage(withWidth: 20), for: .normal)
            playButton.setTitle(NSNumber(value: machineDetails.csAmt).formatted(style: .decimal), for: .normal)
            playButton.setBackgroundImage(UIImage(named: "img_mch_claw_play"), for: .normal)
            playButton.addTarget(self, action: #selector(playButtonClick), for: .touchUpInside)
            view.addSubview(playButton)
            playButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(view.snp.bottomMargin).offset(-70)
            }

        }

    }


}
