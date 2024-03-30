//
// Created by LLL on 2024/3/23.
//

import UIKit
import SwiftyJSON

class EnergyIntroViewController: BaseAlertController, WebSocketDelegate {

    private let progressValueView = UIImageView(image: UIImage(named: "img_energy_value"))
    private let progressValueLabel = UILabel(text: "-", textColor: .white, fontSize: 11, weight: .semibold)
    private let timerLabel = UILabel(text: "00:00", textColor: .white, fontSize: 12, weight: .medium)

    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        WebSocket.client.add(delegate: self)

        let contentView = UIImageView()
        contentView.image = UIImage(named: "img_main_intro_alert")?.resizableImage(withCapInsets: UIEdgeInsets(top: 74, left: 0, bottom: 74, right: 0), resizingMode: .stretch)
        contentView.isUserInteractionEnabled = true
        contentView.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2)
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(contentView.image!.size.width)
        }

        let iconView = UIImageView()
        iconView.image = UIImage(named: "img_profile_energy")?.resizeImage(withWidth: 80)
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.centerX.equalToSuperview()
        }


        let trackView = UIImageView(image: UIImage(named: "img_energy_track"))
        trackView.image = trackView.image?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30), resizingMode: .stretch)
        contentView.addSubview(trackView)
        trackView.snp.makeConstraints { make in
            make.top.equalTo(92)
            make.centerX.equalToSuperview()
            make.width.equalTo(126)
        }

        progressValueView.image = progressValueView.image?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30), resizingMode: .stretch)
        progressValueView.layer.mask = CAShapeLayer()
        progressValueView.layer.mask?.frame = CGRect(x: 0, y: 0, width: 0, height: 16)
        progressValueView.layer.mask?.backgroundColor = UIColor.white.cgColor
        trackView.addSubview(progressValueView)
        progressValueView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }


        progressValueLabel.font = UIFont(name: "qiantuhouheiti", size: 11)
        progressValueLabel.shadowColor = UIColor(hex: 0x000000, alpha: 0.5)
        progressValueLabel.shadowOffset = CGSize(width: 0, height: 1)
        trackView.addSubview(progressValueLabel)
        progressValueLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }


        let textLabel = UILabel(text: nil, textColor: .white, fontSize: 14, weight: .medium)
        textLabel.text = "When energy ≥ 1, AXC or crypto assets can be won through arcade games. Over time, energy will gradually return. Becoming a web3 player or increasing the charging level can greatly improve energy recovery efficiency."
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(trackView.snp.bottom).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.lessThanOrEqualTo(-30)
        }

        let timerView = UIImageView(image: UIImage(named: "img_main_intro_timer"))
        contentView.addSubview(timerView)
        timerView.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.right.equalTo(-6)
        }

        timerView.addSubview(timerLabel)
        timerLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        let closeButton = UIButton(image: UIImage(named: "img_close"))
        closeButton.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin).offset(-50)
        }


        WebSocket.client.send(string: SocketPacket(cmd: SocketCMD.C2S.USER_ENERGY))

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            WebSocket.client.remove(delegate: self)
            timer?.invalidate()
        }
    }

    @objc private func closeButtonClick() {
        presentingViewController?.dismiss(animated: true)
    }


    // MARK: - WebSocketDelegate
    func webSocket(_ webSocket: WebSocket, didConnectToURL url: URL) {

    }

    func webSocketDidDisconnect(_ webSocket: WebSocket, with error: Error?) {
    }

    func webSocket(_ webSocket: WebSocket, didReceiveText text: String) {
        let json = JSON(parseJSON: text)
        let cmd = json["cmd"].intValue
        let data = json["param"]["serverMsg"]
        if cmd == SocketCMD.S2C.USER_ENERGY {
            if data["ttAmt"].floatValue == 0 {
                progressValueView.layer.mask?.frame = CGRect(x: 0, y: 0, width: 126, height: 16)
                progressValueLabel.text = "MAX"
            } else {
                let progress = CGFloat(data["cnAmt"].floatValue / data["ttAmt"].floatValue)
                progressValueView.layer.mask?.frame = CGRect(x: 0, y: 0, width: 126 * progress, height: 16)
                progressValueLabel.text = "\(data["cnAmt"].intValue)/\(data["ttAmt"].intValue)"
            }

            if (timer == nil || timer!.isValid) && data["lfTm"].intValue > 0 {
                var seconds = data["lfTm"].intValue
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    seconds -= 1
                    let hour = seconds / 3600
                    let minute = seconds % 3600 / 60
                    let second = seconds % 60
                    self.timerLabel.text = String(format: "%02d:%02d:%02d", hour, minute, second)
                    if seconds <= 0 {
                        timer.invalidate()
                    }
                }
                timer?.fire()
            }
        }
    }
}


