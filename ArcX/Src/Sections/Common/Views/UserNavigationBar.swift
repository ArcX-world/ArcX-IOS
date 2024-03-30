//
// Created by LLL on 2024/3/21.
//

import UIKit
import SwiftyJSON

class UserNavigationBar: UIView {

    struct Shared {
        static var gameToken: NSNumber? {
            didSet { NotificationCenter.default.post(name: .TokenBalanceDidChangeNotification, object: nil) }
        }

        static var axcToken: NSNumber? {
            didSet { NotificationCenter.default.post(name: .TokenBalanceDidChangeNotification, object: nil) }
        }

        static var energyValue: (NSNumber, NSNumber)? {
            didSet { NotificationCenter.default.post(name: .UserEnergyDidChangeNotification, object: nil) }
        }
    }


    let avatarView = UIImageView()
    let gameTokenView = TokenBalanceView(hasPlus: false)
    let axcTokenView = TokenBalanceView(hasPlus: false)
    let energyView = EnergyProgressView(frame: CGRect())

    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogin), name: .UserDidLoginNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name: .UserDidLogoutNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userinfoDidChange), name: .UserinfoDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tokenBalanceDidChange(_:)), name: .TokenBalanceDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userEnergyDidChange(_:)), name: .UserEnergyDidChangeNotification, object: nil)

        if let profile = Profile.current {
            avatarView.kf.setImage(with: URL(string: profile.plyPct))
        }
        avatarView.backgroundColor = .white
        avatarView.layer.cornerRadius = 28
        avatarView.layer.masksToBounds = true
        avatarView.layer.borderWidth = 1.0
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.isUserInteractionEnabled = true
        addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(10)
            make.size.equalTo(56)
        }

        gameTokenView.value = Shared.gameToken
        addSubview(gameTokenView)
        gameTokenView.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(3)
            make.centerY.equalTo(avatarView)
            make.width.equalTo(108)
        }

        axcTokenView.icon = UIImage(named: "img_axc_token")
        axcTokenView.value = Shared.axcToken
        addSubview(axcTokenView)
        axcTokenView.snp.makeConstraints { make in
            make.left.equalTo(gameTokenView.snp.right).offset(3)
            make.centerY.equalTo(gameTokenView)
            make.width.equalTo(108)
        }

        if let energyValue = Shared.energyValue {
            energyView.setProgress(energyValue.0.intValue, maximum: energyValue.1.intValue)
        }
        addSubview(energyView)
        energyView.snp.makeConstraints { make in
            make.left.equalTo(axcTokenView.snp.right).offset(3)
            make.centerY.equalTo(axcTokenView)
            make.width.equalTo(80)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gameTokenView.snp.updateConstraints { make in
            make.width.equalTo((frame.width - 85) * 0.38)
        }
        axcTokenView.snp.updateConstraints { make in
            make.width.equalTo((frame.width - 85) * 0.38)
        }
        energyView.snp.updateConstraints { make in
            make.width.equalTo((frame.width - 85) * 0.24)
        }
    }


    @objc private func userDidLogin() {

    }

    @objc private func userDidLogout() {
        avatarView.image = nil
        gameTokenView.value = NSNumber(value: 0)
        axcTokenView.value = NSNumber(value: 0)
        energyView.setProgress(0, maximum: 0)
    }


    @objc private func userinfoDidChange() {
        if let profile = Profile.current {
            avatarView.kf.setImage(with: URL(string: profile.plyPct))
        }
    }

    @objc private func tokenBalanceDidChange(_ note: Notification) {
        gameTokenView.value = Shared.gameToken
        axcTokenView.value = Shared.axcToken
    }

    @objc private func userEnergyDidChange(_ note: Notification) {
        if let energyValue = Shared.energyValue {
            energyView.setProgress(energyValue.0.intValue, maximum: energyValue.1.intValue)
        }
    }

}

