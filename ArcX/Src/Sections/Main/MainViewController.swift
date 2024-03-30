//
// Created by LLL on 2024/3/13.
//

import UIKit
import SwiftyJSON
import Kingfisher
import SVGAPlayer


class MainViewController: BaseViewController {

    private let navigationBar = UserNavigationBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogin), name: .UserDidLoginNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name: .UserDidLogoutNotification, object: nil)
        WebSocket.client.add(delegate: self)
        commonInit()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }

    // MARK: - Private

    private func refreshData() {
        if AccessToken.isActive && WebSocket.client.state == .connected {
            WebSocket.client.send(string: SocketPacket(cmd: SocketCMD.C2S.TOKEN_BALANCE))
            WebSocket.client.send(string: SocketPacket(cmd: SocketCMD.C2S.USER_ENERGY))
        }
    }

    @objc private func avatarViewTap() {
        ensureAuth {
            show(ProfileViewController(), sender: nil)
        }
    }

    @objc private func gameTokenViewClick() {
        present(TokenIntroViewController(isGameToken: true), animated: true)
    }

    @objc private func axcTokenViewClick() {
        present(TokenIntroViewController(isGameToken: false), animated: true)
    }

    @objc private func energyViewTap() {
        present(EnergyIntroViewController(), animated: true)
    }

    @objc private func walletButtonClick() {
        show(WalletViewController(), sender: nil)
    }

    @objc private func marketButtonClick() {
        show(MarketViewController(), sender: nil)
    }

    @objc private func pusherButtonClick() {
        show(MachineListViewController(category: .pusher), sender: nil)
    }

    @objc private func dollButtonClick() {
        show(MachineListViewController(category: .claw), sender: nil)
    }

    @objc private func ballButtonClick() {
        show(MachineListViewController(category: .gift), sender: nil)
    }

    @objc private func userDidLogin() {
        refreshData()
        Profile.loadCurrentProfile { _ in }
    }

    @objc private func userDidLogout() {

    }


    private func commonInit() {
        view.backgroundColor = UIColor.black

        let bgView = UIImageView(image: UIImage(named: "img_main_bg"))
        bgView.sizeToFit()
        bgView.center = view.center
        bgView.transform = CGAffineTransform.identity.scaledBy(x: Dimensions.WLR, y: Dimensions.WLR)
        bgView.isUserInteractionEnabled = true
        view.addSubview(bgView)

        let nftAnimatedView = SVGAImageView()
        nftAnimatedView.autoPlay = true
        nftAnimatedView.imageName = "ani_main_nft"
        nftAnimatedView.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        nftAnimatedView.center = CGPoint(x: 166, y: 218)
        bgView.addSubview(nftAnimatedView)

        let pusherAnimatedView = SVGAImageView()
        pusherAnimatedView.autoPlay = true
        pusherAnimatedView.imageName = "ani_main_pusher"
        pusherAnimatedView.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        pusherAnimatedView.center = CGPoint(x: 253, y: 311)
        bgView.addSubview(pusherAnimatedView)

        let clawAnimatedView = SVGAImageView()
        clawAnimatedView.autoPlay = true
        clawAnimatedView.imageName = "ani_main_claw"
        clawAnimatedView.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        clawAnimatedView.center = CGPoint(x: 114, y: 384)
        bgView.addSubview(clawAnimatedView)

        let ballAnimatedView = SVGAImageView()
        ballAnimatedView.autoPlay = true
        ballAnimatedView.imageName = "ani_main_ball"
        ballAnimatedView.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        ballAnimatedView.center = CGPoint(x: 253, y: 451)
        bgView.addSubview(ballAnimatedView)

        let missionAnimatedView = SVGAImageView()
        missionAnimatedView.autoPlay = true
        missionAnimatedView.imageName = "ani_main_mission"
        missionAnimatedView.frame = CGRect(x: 0, y: 0, width: 140, height: 140)
        missionAnimatedView.center = CGPoint(x: 153, y: 548)
        bgView.addSubview(missionAnimatedView)





        let marketButton = UIButton(type: .custom)
        marketButton.frame = CGRect(x: 90, y: 122, width: 130, height: 188)
        marketButton.addTarget(self, action: #selector(marketButtonClick), for: .touchUpInside)
        bgView.addSubview(marketButton)


        let pusherButton = UIButton(type: .custom)
        pusherButton.frame = CGRect(x: 206, y: 266, width: 168, height: 138)
        pusherButton.addTarget(self, action: #selector(pusherButtonClick), for: .touchUpInside)
        bgView.addSubview(pusherButton)

        let clawButton = UIButton(type: .custom)
        clawButton.frame = CGRect(x: 38, y: 305, width: 154, height: 170)
        clawButton.addTarget(self, action: #selector(dollButtonClick), for: .touchUpInside)
        bgView.addSubview(clawButton)

        let ballButton = UIButton(type: .custom)
        ballButton.frame = CGRect(x: 212, y: 412, width: 162, height: 162)
        ballButton.addTarget(self, action: #selector(ballButtonClick), for: .touchUpInside)
        bgView.addSubview(ballButton)

        let missionButton = UIButton(type: .custom)
        missionButton.frame = CGRect(x: 48, y: 486, width: 170, height: 170)
        bgView.addSubview(missionButton)


        navigationBar.avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarViewTap)))
        navigationBar.gameTokenView.addTarget(self, action: #selector(gameTokenViewClick), for: .touchUpInside)
        navigationBar.axcTokenView.addTarget(self, action: #selector(axcTokenViewClick), for: .touchUpInside)
        navigationBar.energyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(energyViewTap)))
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.equalToSuperview()
        }

        let walletButton = UIButton(image: UIImage(named: "img_main_wallet")?.resizeImage(withWidth: 56 * Dimensions.WLR))
        walletButton.addTarget(self, action: #selector(walletButtonClick), for: .touchUpInside)
        view.addSubview(walletButton)
        walletButton.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.right.equalTo(-6)
        }

        let airdropButton = UIButton(image: UIImage(named: "img_main_airdrop")?.resizeImage(withWidth: 62 * Dimensions.WLR))
        view.addSubview(airdropButton)
        airdropButton.snp.makeConstraints { make in
            make.top.equalTo(walletButton.snp.bottom).offset(4)
            make.centerX.equalTo(walletButton)
        }


    }


}

// MARK: - WebSocketDelegate
extension MainViewController: WebSocketDelegate {

    func webSocket(_ webSocket: WebSocket, didConnectToURL url: URL) {
        refreshData()
    }

    func webSocketDidDisconnect(_ webSocket: WebSocket, with error: Error?) {
    }

    func webSocket(_ webSocket: WebSocket, didReceiveText text: String) {
        let json = JSON(parseJSON: text)
        let cmd = json["cmd"].intValue
        let data = json["param"]["serverMsg"]
        if cmd == SocketCMD.S2C.TOKEN_BALANCE {
            UserNavigationBar.Shared.gameToken = data["gdAmt"].numberValue
            UserNavigationBar.Shared.axcToken = data["axcAmt"].numberValue
        }
        else if cmd == SocketCMD.S2C.USER_ENERGY {
            UserNavigationBar.Shared.energyValue = (data["cnAmt"].numberValue, data["ttAmt"].numberValue)
        }
    }
}