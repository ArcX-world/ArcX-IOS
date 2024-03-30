//
// Created by LLL on 2024/3/18.
//

import UIKit

class SettingsViewController: CommonAlertController {

    private let soundSwitchButton = UIButton(type: .custom)

    override func viewDidLoad() {
        title = "Setting"
        super.viewDidLoad()

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(60)
            make.centerX.equalToSuperview()
            make.width.equalTo(278)
            make.bottom.equalTo(-30)
        }

        let isOn = AudioSession.shareInstance.active(with: .default)
        setSoundSwitchButtonOn(isOn)
        soundSwitchButton.addTarget(self, action: #selector(soundSwitchButtonClick), for: .touchUpInside)


        let passwordButton = UIButton(type: .custom)
        let setTitle = NSAttributedString(string: "SET", attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .heavy),
            .shadow: NSShadow().then {
                $0.shadowColor = UIColor(hex: 0xF6BFEA)
                $0.shadowOffset = CGSize(width: 0, height: 1)
            }
        ])
        passwordButton.setAttributedTitle(setTitle, for: .normal)
        passwordButton.titleEdgeInsets = UIEdgeInsets(top: -1, left: 0, bottom: 1, right: 0)
        passwordButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        passwordButton.setBackgroundImage(UIImage(named: "img_mine_alert_btn")?.resizeImage(withWidth: 64), for: .normal)
        passwordButton.addTarget(self, action: #selector(passwordButtonClick), for: .touchUpInside)

        let msgButton = UIButton(type: .custom)
        msgButton.setImage(UIImage(named: "img_setting_msg"), for: .normal)
        msgButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 0)
        msgButton.addTarget(self, action: #selector(msgButtonClick), for: .touchUpInside)



        let soundViewCell = SettingPlainViewCell(frame: CGRect(x: 0, y: 0, width: 278, height: 44))
        soundViewCell.iconView.image = UIImage(named: "img_setting_voice")
        soundViewCell.titleLabel.text = "Sound"
        soundViewCell.accessoryView = soundSwitchButton
        stackView.addArrangedSubview(soundViewCell)

        let languageViewCell = SettingPlainViewCell(frame: CGRect(x: 0, y: 0, width: 278, height: 44))
        languageViewCell.iconView.image = UIImage(named: "img_setting_language")
        languageViewCell.titleLabel.text = "Language"
        languageViewCell.subtitleLabel.text = "English"
        stackView.addArrangedSubview(languageViewCell)

        let emailViewCell = SettingPlainViewCell(frame: CGRect(x: 0, y: 0, width: 278, height: 44))
        emailViewCell.iconView.image = nil
        emailViewCell.titleLabel.text = "Email"
        emailViewCell.subtitleLabel.text = Profile.current?.email
        stackView.addArrangedSubview(emailViewCell)

        let passwordViewCell = SettingPlainViewCell(frame: CGRect(x: 0, y: 0, width: 278, height: 44))
        passwordViewCell.iconView.image = nil
        passwordViewCell.titleLabel.text = "Password"
        passwordViewCell.accessoryView = passwordButton
        stackView.addArrangedSubview(passwordViewCell)

        let supportViewCell = SettingPlainViewCell(frame: CGRect(x: 0, y: 0, width: 278, height: 44))
        supportViewCell.iconView.image = UIImage(named: "img_setting_support")
        supportViewCell.titleLabel.text = "Support"
        supportViewCell.accessoryView = msgButton
        stackView.addArrangedSubview(supportViewCell)

        let deleteViewCell = SettingPlainViewCell(frame: CGRect(x: 0, y: 0, width: 278, height: 44))
        deleteViewCell.iconView.image = UIImage(named: "img_setting_delete")
        deleteViewCell.titleLabel.text = "Delete Account"
        stackView.addArrangedSubview(deleteViewCell)

        let quitViewCell = SettingPlainViewCell(frame: CGRect(x: 0, y: 0, width: 278, height: 44))
        quitViewCell.iconView.image = nil
        quitViewCell.titleLabel.text = "Quit Account"
        quitViewCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(quitCellClick)))
        stackView.addArrangedSubview(quitViewCell)

    }



    // MARK: - Private

    private func setSoundSwitchButtonOn(_ isOn: Bool) {
        if isOn {
            soundSwitchButton.setBackgroundImage(UIImage(named: "img_setting_switch_on"), for: .normal)
            soundSwitchButton.setBackgroundImage(UIImage(named: "img_setting_switch_on"), for: .highlighted)
        } else {
            soundSwitchButton.setBackgroundImage(UIImage(named: "img_setting_switch_off"), for: .normal)
            soundSwitchButton.setBackgroundImage(UIImage(named: "img_setting_switch_off"), for: .highlighted)
        }
    }

    @objc private func soundSwitchButtonClick() {
        var isOn = AudioSession.shareInstance.active(with: .default)
        isOn = !isOn
        AudioSession.shareInstance.setActive(isOn, with: .default)
        setSoundSwitchButtonOn(isOn)
    }

    @objc private func passwordButtonClick() {
        present(PasswordViewController(), animated: true)
    }

    @objc private func msgButtonClick() {

    }

    @objc private func quitCellClick() {
        Profile.current = nil
        AccessToken.current = nil
        NotificationCenter.default.post(name: .UserDidLogoutNotification, object: nil)
        weak var presentingViewController = presentingViewController
        presentingViewController?.dismiss(animated: true) {
            (presentingViewController as? UINavigationController)?.popToRootViewController(animated: true)
        }
    }

}
