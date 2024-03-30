//
// Created by LLL on 2024/3/16.
//

import UIKit

class GenderEditViewController: CommonAlertController {

    private var value: Int = 1

    private let genders = [ 1, 2 ]

    private var buttons: [UIButton] = []

    override func viewDidLoad() {
        title = "Gender"
        addAction(AlertAction(title: "SAVE") { [weak self] _ in
            self?.save()
        })

        super.viewDidLoad()

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 44
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(98)
            make.centerX.equalToSuperview()
        }

        genders.forEach {
            let btn = buildRadioButton(with: $0)
            stackView.addArrangedSubview(btn)
            buttons.append(btn)
        }

        value = Profile.current!.sex
        if let index = genders.index(of: value) {
            DispatchQueue.main.async {
                self.buttons[index].isSelected = true
            }
        }

    }




    // MARK: - Private

    private func buildRadioButton(with gender: Int) -> UIButton {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 88, height: 48), false, 0)

        UIImage.pure(color: .white, size: CGSize(width: 30, height: 30), cornerRadius: 4)
                .draw(at: CGPoint(x: 0, y: 9))

        UIImage.pure(color: .white, size: CGSize(width: 48, height: 48), cornerRadius: 4)
                .draw(at: CGPoint(x: 40, y: 0))

        UIImage(named: "img_gender_0\(gender)")?
                .draw(in: CGRect(x: 42, y: 2, width: 44, height: 44))
        let normalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 88, height: 48), false, 0)
        
        UIImage.pure(color: .white, size: CGSize(width: 30, height: 30), cornerRadius: 4)
                .draw(at: CGPoint(x: 0, y: 9))

        UIImage.pure(color: .white, size: CGSize(width: 48, height: 48), cornerRadius: 4)
                .draw(at: CGPoint(x: 40, y: 0))

        UIImage(named: "img_checkbox")?
                .draw(in: CGRect(x: 5, y: 14, width: 20, height: 20))

        UIImage(named: "img_gender_0\(gender)")?
                .draw(in: CGRect(x: 42, y: 2, width: 44, height: 44))
        let highlightImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        let btn = UIButton(type: .custom)
        btn.setBackgroundImage(normalImage, for: .normal)
        btn.setBackgroundImage(highlightImage, for: .highlighted)
        btn.setBackgroundImage(highlightImage, for: .selected)
        btn.setBackgroundImage(highlightImage, for: [ .highlighted, .selected ])
        btn.addTarget(self, action: #selector(radioButtonClick(_:)), for: .touchUpInside)
        return btn
    }

    @objc private func radioButtonClick(_ sender: UIButton) {
        guard let index = buttons.index(of: sender) else { return }
        value = genders[index]
        buttons.forEach({ $0.isSelected = $0 == sender })
    }
    
    @objc private func save() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        userProvider.request(.updateUserinfo(nickname: Profile.current!.plyNm, gender: value)) { result in
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
