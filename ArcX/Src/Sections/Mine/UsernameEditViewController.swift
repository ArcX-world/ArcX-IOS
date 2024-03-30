//
// Created by LLL on 2024/3/16.
//

import Foundation

class UsernameEditViewController: CommonAlertController, UITextFieldDelegate {

    let nameTF = UITextField()

    override func viewDidLoad() {
        title = "Change name"
        addAction(AlertAction(title: "SAVE") { [weak self] _ in
            self?.save()
        })
        super.viewDidLoad()

        nameTF.text = Profile.current?.plyNm
        nameTF.font = UIFont.systemFont(ofSize: 14, weight: .heavy)
        nameTF.textAlignment = .center
        nameTF.delegate = self
        nameTF.enablesReturnKeyAutomatically = true
        nameTF.backgroundColor = .white
        nameTF.layer.cornerRadius = 12
        nameTF.layer.masksToBounds = true
        contentView.addSubview(nameTF)
        nameTF.snp.makeConstraints { make in
            make.top.equalTo(95)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 276, height: 56))
        }

    }


    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    // MARK: - Private

    @objc private func save() {
        nameTF.resignFirstResponder()
        let hud = ProgressHUD.showHUD(addedTo: view)
        userProvider.request(.updateUserinfo(nickname: nameTF.text!, gender: Profile.current!.sex)) { result in
            hud.hide()
            switch result {
            case .success(let response):
                self.presentingViewController?.dismiss(animated: true)
                Profile.loadCurrentProfile { _ in  }
                break
            case .failure(let error):
                ToastView.showToast(error.localizedDescription, in: self.view)
                break
            }
        }
    }

}
