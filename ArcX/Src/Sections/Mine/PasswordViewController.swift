//
// Created by LLL on 2024/3/19.
//

import UIKit

class PasswordViewController: CommonAlertController {

    private let emailTF = UITextField()
    private let codeTF = UITextField()
    private let passwordTF = UITextField()

    override func viewDidLoad() {
        title = "Password"
        addAction(AlertAction(title: "SAVE") { [weak self] _ in
            self?.save()
        })
        super.viewDidLoad()

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(52)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(buttonsStackView.snp.top).offset(-16)
        }

        emailTF.isEnabled = false
        emailTF.text = Profile.current?.email
        emailTF.delegate = self
        stackView.addArrangedSubview(buildInputView(with: "Email", textField: emailTF))

        codeTF.delegate = self
        stackView.addArrangedSubview(buildInputView(with: "Email verification code", textField: codeTF))

        passwordTF.delegate = self
        stackView.addArrangedSubview(buildInputView(with: "New password", textField: passwordTF))


        let sendButton = UIButton.plain(title: "SEND", titleColor: UIColor(hex: 0x78351C), fontSize: 14, weight: .heavy)
        sendButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        sendButton.addTarget(self, action: #selector(sendButtonClick), for: .touchUpInside)
        sendButton.sizeToFit()
        codeTF.rightView = sendButton
        codeTF.rightViewMode = .always

    }


    // MARK: - Private

    @objc private func sendButtonClick() {

    }

    @objc private func save() {

    }

    private func buildInputView(with title: String, textField: UITextField) -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 278, height: 68))

        let titleLabel = UILabel(text: title, textColor: UIColor(hex: 0x333333), fontSize: 14, weight: .heavy)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(4)
            make.left.equalTo(10)
        }

        textField.textColor = UIColor(hex: 0x333333)
        textField.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.layer.masksToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 44))
        textField.leftViewMode = .always
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.left.bottom.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 278, height: 44))
        }
        return view
    }

}

// MARK: - UITextFieldDelegate

extension PasswordViewController: UITextFieldDelegate {

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
