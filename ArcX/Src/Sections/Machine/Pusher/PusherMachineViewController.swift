//
// Created by LLL on 2024/3/14.
//

import UIKit
import SwiftyJSON
import SVGAPlayer

class PusherMachineViewController: MachineBasedViewController {

    private var odds: Int = 0 {
        didSet { UserDefaults.standard.setValue(odds, forKey: "PUSHER_ODDS_\(machineDetails.devId)") }
    }

    private let avatarView = UIImageView()
    private let gameTokenView = TokenBalanceView(hasPlus: true)
    private let axcTokenView = TokenBalanceView(hasPlus: true)
    private let viewerStackView = MachineViewerStackView()
    private let toolbar = MachineToolbar()
    private let timeLabel = UILabel(text: nil, textColor: UIColor(hex: 0xFFFFFF, alpha: 0.8))
    private let energyView = EnergyProgressView(frame: CGRect())
    private let dragonBallView = DragonBallProgressView(frame: CGRect())
    private let slotsButton = MachineButton(frame: UIScreen.main.bounds)
    private let comboView = PusherComboView(frame: CGRect())


    override func viewDidLoad() {
        CMD_C2S_DEFAULT = 2001
        CMD_S2C_DEFAULT = 2002
        super.viewDidLoad()
        commonInit()
    }

    override var duration: Int {
        return 60
    }

    override func join() {
        super.join()
        send(cmd: SocketCMD.C2S.DB_INFO)
        send(cmd: SocketCMD.C2S.USER_ENERGY)
        odds = UserDefaults.standard.integer(forKey: "PUSHER_ODDS_\(machineDetails.devId)")
    }

    override func stopTimer() {
        super.stopTimer()
        timeLabel.text = nil
    }

    override func onTickTack(_ seconds: Int) {
        super.onTickTack(seconds)
        if 0 < seconds && seconds <= 10 {
            timeLabel.text = "\(seconds)"
        } else {
            timeLabel.text = nil
        }

        if seconds == 0 {
            quitGame()
        }
    }

    override func webSocket(_ webSocket: WebSocket, didReceiveJson json: JSON) {
        super.webSocket(webSocket, didReceiveJson: json)
        let cmd = json["cmd"].intValue
        let data = json["param"]["serverMsg"]
        let errorCode = json["param"]["errorCode"].intValue

        if errorCode == 1 {
            if cmd == CMD_S2C_DEFAULT {
                if data["hdlTp"].int == SocketSignal.PUSH {
                    startTimer(duration)
                }
                if let balance = data["gdAmt"].number {
                    gameTokenView.value = balance
                }
                if let getToken = data["flAmt"].number, getToken.intValue > 0 {
                    startTimer(duration)
                    GameTokenAnimatedView(number: getToken).startAnimation(in: view)

                    let count = getToken.intValue / odds
                    for _ in 0..<count {
                        comboView.hit()
                    }
                }
            }
            else if cmd == SocketCMD.S2C.TOKEN_BALANCE {
                gameTokenView.value = data["gdAmt"].number
                axcTokenView.value = data["axcAmt"].number
            }
            else if cmd == SocketCMD.S2C.MCH_INFO {
                if data["vsUsrTbln"].arrayValue.count != viewerStackView.dataSource.count {
                    if let array = Array<MachinePlayer>.from(json: data["vsUsrTbln"].arrayObject) {
                        viewerStackView.dataSource = array
                    }
                }
            }
            else if cmd == SocketCMD.S2C.USER_ENERGY {
                let val = data["cnAmt"].intValue
                let total = data["ttAmt"].intValue
                energyView.setProgress(val, maximum: total)
            }
            else if cmd == SocketCMD.S2C.DB_INFO {
                dragonBallView.value = data["dgbAmt"].intValue
            }
            else if cmd == SocketCMD.S2C.DB_BONUS {
                startTimer(duration)
                //dragonBallView.value = data["cnbAmt"].intValue
                if let bonusItems = Array<BonusItem>.from(json: data["awdTbln"].arrayObject) {
                    let bonusViewController = DBBonusViewController(bonusItems: bonusItems)
                    bonusViewController.ballPosition = dragonBallView.ballViews[data["cnbAmt"].intValue-1].convert(CGPoint(x: 5, y: 5), to: view)
                    bonusViewController.axcPosition = axcTokenView.iconView.convert(CGPoint(x: 12, y: 12), to: view)
                    bonusViewController.onDismissed = { [weak self] in
                        guard let self = self else { return }
                        self.send(cmd: SocketCMD.C2S.DB_INFO)
                    }
                    present(bonusViewController, animated: true)
                }
                if let trainMsg = DBTrain.from(json: data["dgTnTbln"].dictionaryObject) {
                    let trainViewController = DBTrainViewController(train: trainMsg)
                    trainViewController.onDismissed = { [weak self] in
                        guard let self = self else { return }
                        self.send(cmd: SocketCMD.C2S.DB_INFO)
                    }
                    present(trainViewController, animated: true)
                }
            }
        } else {
            // 1013 设备玩家不匹配
            // 1011 设备占用中
            if errorCode == 1024 || errorCode == 1028 {
                send(cmd: SocketCMD.C2S.MCH_INFO)
            }
            // 1012 余额不足
            if errorCode == 1012 {
                slotsButton.stop()
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
            let hud = ProgressHUD.showHUD(addedTo: view)
            machineProvider.request(.getMachine(id: machineDetails.devId)) { result in
                hud.hide()
                switch result {
                case .success(let response):
                    do {
                        let machineDetails = try response.map(MachineDetails.self, atKeyPath: "serverMsg")
                        let pickerController = PusherOddsPickerController(machine: machineDetails)
                        pickerController.onSelect = { item in
                            self.odds = item.mulAmt
                            self.startGame(with: [ "gdMul": item.mulAmt ])
                        }
                        self.present(pickerController, animated: true)
                    } catch {
                        logger.error(error)
                    }
                    break
                case .failure(let error):
                    ToastView.showToast(error.localizedDescription, in: self.view)
                    break
                }
            }
        }
    }

    override func prepareForStart() {
        super.prepareForStart()

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
        toolbar.items = [ toolbar.quitButton, toolbar.voiceButton, toolbar.guideButton, toolbar.repairButton ]
        toolbar.quitButton.addTarget(self, action: #selector(quitButtonClick), for: .touchUpInside)
        toolbar.voiceButton.addTarget(self, action: #selector(voiceButtonClick), for: .touchUpInside)
        toolbar.repairButton.addTarget(self, action: #selector(repairButtonClick), for: .touchUpInside)


        timeLabel.font = UIFont(name: "qiantuhouheiti", size: 150)
        timeLabel.isUserInteractionEnabled = false

        slotsButton.add(listener: MachineButton.TouchDownListener(interval: 0.3) { [weak self] in
            self?.send(signal: SocketSignal.PUSH)
            AudioPlayer(fileName: "sound_mch_push.mp3")?.play()
        })
        slotsButton.add(listener: MachineButton.LongPressListener(interval: 0.3) { [weak self] in
            self?.send(signal: SocketSignal.PUSH)
            AudioPlayer(fileName: "sound_mch_push.mp3")?.play()
        })
        slotsButton.add(listener: MachineButton.AutomaticListener(threshold: 1.5, interval: 0.35, isTrack: true, callback: { [weak self] in
            self?.send(signal: SocketSignal.PUSH)
            AudioPlayer(fileName: "sound_mch_push.mp3")?.play()
        }, onBegin: { [weak self] in
            guard let self = self else { return }
            ToastView.showToast("开始自动投币", in: self.view)
        }, onEnd: { [weak self] in
            guard let self = self else { return }
            ToastView.showToast("停止自动投币", in: self.view)
        }))

    }

    override func layoutSubviews() {
        super.layoutSubviews()

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
            make.top.equalTo(avatarView).offset(7)
            make.left.equalTo(avatarView.snp.right).offset(6)
             make.width.equalTo((view.frame.width - 196) * 0.55)
        }

        view.addSubview(axcTokenView)
        axcTokenView.snp.makeConstraints { make in
            make.centerY.equalTo(gameTokenView)
            make.left.equalTo(gameTokenView.snp.right).offset(3)
            make.width.equalTo((view.frame.width - 196) * 0.45)
        }

        toolbar.setSwitchOn(false)
        view.addSubview(toolbar)
        toolbar.snp.makeConstraints { make in
            make.centerY.equalTo(avatarView)
            make.right.equalTo(-10)
        }

        view.addSubview(viewerStackView)
        viewerStackView.snp.makeConstraints { make in
            make.right.equalTo(toolbar.snp.left).offset(-6)
            make.centerY.equalTo(toolbar)
        }


        if mode == .player {
            gameTokenView.isHidden = false
            axcTokenView.isHidden = false

            view.addSubview(dragonBallView)
            dragonBallView.snp.makeConstraints { make in
                make.top.equalTo(avatarView.snp.bottom).offset(10)
                make.left.equalTo(8)
            }

            view.addSubview(energyView)
            energyView.snp.makeConstraints { make in
                make.top.equalTo(dragonBallView.snp.bottom).offset(4)
                make.left.equalTo(4)
                make.width.equalTo(98)
            }

            view.addSubview(timeLabel)
            timeLabel.snp.makeConstraints { make in
                make.top.equalTo(view.snp.topMargin).offset(88)
                make.centerX.equalToSuperview()
            }

            view.insertSubview(slotsButton, at: 0)
            slotsButton.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }

            view.addSubview(comboView)
            comboView.snp.makeConstraints { make in
                make.left.equalTo(6)
                make.top.equalTo(view.snp.centerY).offset(100)
            }

        }
        else if mode == .viewer {
            gameTokenView.isHidden = true
            axcTokenView.isHidden = true
        }
        else if mode == .guest {
            gameTokenView.isHidden = false
            axcTokenView.isHidden = false

            let playButton = UIButton(image: UIImage(named: "img_mch_ps_play"))
            playButton.addTarget(self, action: #selector(playButtonClick), for: .touchUpInside)
            view.addSubview(playButton)
            playButton.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(view.snp.bottomMargin).offset(-120)
            }

        }
    }
}
