//
// Created by LLL on 2024/3/13.
//

import UIKit
import SnapKit

class LoginViewController: BaseViewController {

    enum LoginType {
        case password
        case verification
    }

    private var loginType = LoginType.password

    private var timer: Timer?

    private let emailTF = UITextField()
    private let passwordTF = UITextField()
    private let codeTF = UITextField()
    private let codeButton = UIButton(type: .custom)
    private let emailTipsLabel = UILabel(text: nil, textColor: UIColor(hex: 0xFFAAAA), fontSize: 12, weight: .semibold)
    private let passwordTipsLabel = UILabel(text: nil, textColor: UIColor(hex: 0xFFAAAA), fontSize: 12, weight: .semibold)
    private let agreeButton = UIButton(type: .custom)
    private let verificationButton = UIButton(type: .custom)
    private let accountButton = UIButton(type: .custom)


    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        //switchVerificationLogin()
        switchPasswordLogin()

        #if DEBUG
        emailTF.text = "liyanhuadev@icloud.com"
        #endif
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        view.endEditing(true)
    }

    // MARK: - Private

    @objc private func agreeButtonClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }

    @objc private func guestButtonClick() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        loginProvider.request(.guestLogin) { result in
            hud.hide()
            switch result {
            case .success(let response):
                do {
                    if let json = try response.mapJSON() as? [String: Any] {
                        self.processToken(json["serverMsg"]!)
                    }
                } catch {}
                break
            case .failure(let error):
                ToastView.showToast(error.localizedDescription, in: self.view)
                break
            }
        }
    }

    @objc private func codeButtonClick() {
        if emailTF.text!.isEmpty {
            emailTipsLabel.text = "Please enter email address"
            return
        }
        if let expression = try? NSRegularExpression(pattern: "\\w+@\\w+(\\.\\w+)+", options: .caseInsensitive) {
            let matches = expression.matches(in: emailTF.text!, range: NSMakeRange(0, emailTF.text!.count))
            if matches.isEmpty {
                emailTipsLabel.text = "Incorrect email address"
                return
            }
        }
        emailTipsLabel.text = nil

        let hud = ProgressHUD.showHUD(addedTo: view)
        loginProvider.request(.sendCode(email: emailTF.text!)) { result in
            hud.hide()
            switch result {
            case .success(let response):
                self.startTimer()
                break
            case .failure(let error):
                self.emailTipsLabel.text = error.localizedDescription
                break
            }
        }
    }

    private func startTimer() {
        timer?.invalidate()
        codeButton.isEnabled = false
        var seconds: Int = 60
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            seconds -= 1
            self.codeButton.setTitle("\(seconds)S", for: .disabled)
            if seconds <= 0 {
                self.codeButton.isEnabled = true
                timer.invalidate()
            }
        }
        timer?.fire()
    }

    @objc private func loginButtonClick() {
        guard agreeButton.isSelected else {
            return
        }

        if loginType == .password {
            if passwordTF.text!.isEmpty {
                passwordTipsLabel.text = "Please enter password"
                return
            }
            passwordTipsLabel.text = nil

            let hud = ProgressHUD.showHUD(addedTo: view)
            loginProvider.request(.emailLogin(email: emailTF.text!, code: nil, password: passwordTF.text!)) { result in
                hud.hide()
                switch result {
                case .success(let response):
                    do {
                        if let json = try response.mapJSON() as? [String: Any] {
                            self.processToken(json["serverMsg"]!)
                        }
                    } catch {}
                    break
                case .failure(let error):
                    self.passwordTipsLabel.text = error.localizedDescription
                    break
                }
            }
        }

        if loginType == .verification {
            if codeTF.text!.isEmpty {
                passwordTipsLabel.text = "Please enter verification code"
                return
            }
            passwordTipsLabel.text = nil

            let hud = ProgressHUD.showHUD(addedTo: view)
            loginProvider.request(.emailLogin(email: emailTF.text!, code: codeTF.text!, password: nil)) { result in
                hud.hide()
                switch result {
                case .success(let response):
                    do {
                        if let json = try response.mapJSON() as? [String: Any] {
                            self.processToken(json["serverMsg"]!)
                        }
                    } catch {}
                    break
                case .failure(let error):
                    self.passwordTipsLabel.text = error.localizedDescription
                    break
                }
            }
        }
    }

    @objc private func switchVerificationLogin() {
        loginType = .verification
        verificationButton.isHidden = true
        accountButton.isHidden = !verificationButton.isHidden
        passwordTF.isHidden = verificationButton.isHidden
        codeTF.isHidden = !verificationButton.isHidden
        codeButton.isHidden = codeTF.isHidden
        passwordTipsLabel.text = nil
    }

    @objc private func switchPasswordLogin() {
        loginType = .password
        verificationButton.isHidden = false
        accountButton.isHidden = !verificationButton.isHidden
        passwordTF.isHidden = verificationButton.isHidden
        codeTF.isHidden = !verificationButton.isHidden
        codeButton.isHidden = codeTF.isHidden
        emailTipsLabel.text = nil
        passwordTipsLabel.text = nil
    }

    private func processToken(_ token: Any) {
        let map = token as! [String: Any]
        let accessToken = map["aesTkn"] as! String
        let refreshToken = map["refTkn"] as! String
        let userId = map["arcxUid"] as! Int
        let expire = map["refOt"] as! Double
        let expireData = Date(timeIntervalSince1970: expire / 1000)
        AccessToken.current = AccessToken(accessToken: accessToken, expireDate: expireData, refreshToken: refreshToken, userId: userId)
        NotificationCenter.default.post(name: .UserDidLoginNotification, object: nil)
        presentingViewController?.dismiss(animated: true)
    }

    private func shakeView(_ view: UIView, duration: TimeInterval) {
        let animation = CASpringAnimation(keyPath: "position.x")
        animation.fromValue = NSNumber(value: view.layer.position.x - 3)
        animation.toValue = NSNumber(value: view.layer.position.x + 3)
        animation.repeatCount = 3
        animation.duration = duration
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.isRemovedOnCompletion = true
        view.layer.add(animation, forKey: "shake")
    }

    private func commonInit() {
        view.backgroundColor = .black

        let bgView = UIImageView(image: UIImage(named: "img_main_blur_bg"))
        bgView.frame = view.bounds
        view.insertSubview(bgView, at: 0)


        let contentView = UIImageView(image: UIImage(named: "img_login_bg"))
        contentView.isUserInteractionEnabled = true
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        let emailView = UIView()
        emailView.backgroundColor = UIColor(hex: 0xE0D7FF)
        emailView.layer.cornerRadius = 8
        contentView.addSubview(emailView)
        emailView.snp.makeConstraints { make in
            make.top.equalTo(146)
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.height.equalTo(44)
        }

        emailTF.textColor = UIColor(hex: 0x333333)
        emailTF.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        emailTF.attributedPlaceholder = NSAttributedString(string: "Enter your email", attributes: [ .foregroundColor: UIColor(hex: 0xA99CDA) ])
        emailTF.keyboardType = .emailAddress
        emailView.addSubview(emailTF)
        emailTF.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }

        contentView.addSubview(emailTipsLabel)
        emailTipsLabel.snp.makeConstraints { make in
            make.top.equalTo(emailView.snp.bottom).offset(6)
            make.left.equalTo(emailView)
        }


        let passwordView = UIView()
        passwordView.backgroundColor = UIColor(hex: 0xE0D7FF)
        passwordView.layer.cornerRadius = 8
        contentView.addSubview(passwordView)
        passwordView.snp.makeConstraints { make in
            make.top.equalTo(emailView.snp.bottom).offset(30)
            make.left.equalTo(24)
            make.right.equalTo(-24)
            make.height.equalTo(44)
        }

        passwordTF.textColor = UIColor(hex: 0x333333)
        passwordTF.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        passwordTF.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [ .foregroundColor: UIColor(hex: 0xA99CDA) ])
        passwordView.addSubview(passwordTF)
        passwordTF.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }


        codeTF.textColor = UIColor(hex: 0x333333)
        codeTF.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        codeTF.attributedPlaceholder = NSAttributedString(string: "Verification code", attributes: [ .foregroundColor: UIColor(hex: 0xA99CDA) ])
        passwordView.addSubview(codeTF)
        codeTF.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 50))
        }

        codeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        codeButton.setTitle("Send", for: .normal)
        codeButton.setTitleColor(UIColor(hex: 0x78351C), for: .normal)
        codeButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        codeButton.addTarget(self, action: #selector(codeButtonClick), for: .touchUpInside)
        passwordView.addSubview(codeButton)
        codeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }


        contentView.addSubview(passwordTipsLabel)
        passwordTipsLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordView.snp.bottom).offset(6)
            make.left.equalTo(passwordView)
        }

        agreeButton.setImage(UIImage(named: "img_login_checkbox"), for: .normal)
        agreeButton.setImage(UIImage(named: "img_login_checkbox_selected"), for: .selected)
        agreeButton.setImage(UIImage(named: "img_login_checkbox_selected"), for: .highlighted)
        agreeButton.setImage(UIImage(named: "img_login_checkbox_selected"), for: [ .selected, .highlighted ])
        agreeButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 40)
        agreeButton.addTarget(self, action: #selector(agreeButtonClick(_:)), for: .touchUpInside)
        contentView.addSubview(agreeButton)
        agreeButton.snp.makeConstraints { make in
            make.top.equalTo(passwordView.snp.bottom).offset(40)
            make.left.equalTo(passwordView)
        }


        let policyLabel = AttributedLabel()
        policyLabel.textColor = UIColor(hex: 0xBCACF5)
        policyLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        policyLabel.numberOfLines = 0
        policyLabel.lineBreakMode = .byWordWrapping
        policyLabel.append(text: "I agree to ")
        policyLabel.append(link: "", text: "ArcX Terms of use ", textColor: UIColor(hex: 0xFF9A9A))
        contentView.insertSubview(policyLabel, belowSubview: agreeButton)
        policyLabel.snp.makeConstraints { make in
            make.left.equalTo(agreeButton).offset(20)
            make.centerY.equalTo(agreeButton)
        }


        let loginButton = UIButton.primary(title: "Login")
        loginButton.addTarget(self, action: #selector(loginButtonClick), for: .touchUpInside)
        contentView.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(agreeButton.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }


        let verificationTitle = NSAttributedString(string: "Verification login", attributes: [
            .foregroundColor: UIColor(hex: 0xBCACF5),
            .font: UIFont.systemFont(ofSize: 14, weight: .bold),
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor(hex: 0xBCACF5),
        ])
        verificationButton.setAttributedTitle(verificationTitle, for: .normal)
        verificationButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        verificationButton.addTarget(self, action: #selector(switchVerificationLogin), for: .touchUpInside)
        contentView.addSubview(verificationButton)
        verificationButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-6)
        }

        let accountTitle = NSAttributedString(string: "Account login", attributes: [
            .foregroundColor: UIColor(hex: 0xBCACF5),
            .font: UIFont.systemFont(ofSize: 14, weight: .bold),
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor(hex: 0xBCACF5),
        ])
        accountButton.setAttributedTitle(accountTitle, for: .normal)
        accountButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        accountButton.addTarget(self, action: #selector(switchPasswordLogin), for: .touchUpInside)
        contentView.addSubview(accountButton)
        accountButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-6)
        }


        let guestButton = UIButton.plain(title: "Guest Login", titleColor: .white)
        guestButton.addTarget(self, action: #selector(guestButtonClick), for: .touchUpInside)
        view.addSubview(guestButton)
        guestButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
        }
    }

}
