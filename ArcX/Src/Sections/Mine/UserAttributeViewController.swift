//
// Created by LLL on 2024/3/18.
//

import UIKit

class UserAttributeViewController: BaseAlertController {

    var attr: UserAttribute!

    init(attr: UserAttribute) {
        super.init(nibName: nil, bundle: nil)
        self.attr = attr
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let contentView = UIImageView(image: UIImage(named: "img_profile_attr_alert"))
        contentView.isUserInteractionEnabled = true
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        let typeView = UIImageView()
        typeView.contentMode = .scaleAspectFit
        typeView.image = attributeImage(with: attr.atbTp)
        contentView.addSubview(typeView)
        typeView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 86, height: 86))
        }

        let arrowView = UIImageView(image: UIImage(named: "img_profile_attr_transfer"))
        contentView.addSubview(arrowView)
        arrowView.snp.makeConstraints { make in
            make.top.equalTo(typeView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }


        let fromLabel = UILabel(text: "LV\(attr.lv)", textColor: .white, fontSize: 20, weight: .heavy)
        contentView.addSubview(fromLabel)
        fromLabel.snp.makeConstraints { make in
            make.centerY.equalTo(arrowView)
            make.right.equalTo(arrowView.snp.left).offset(-10)
        }

        let toLabel = UILabel(text: "LV\(attr.nxLv)", textColor: .white, fontSize: 20, weight: .heavy)
        contentView.addSubview(toLabel)
        toLabel.snp.makeConstraints { make in
            make.centerY.equalTo(arrowView)
            make.left.equalTo(arrowView.snp.right).offset(10)
        }


        let titleLabel = UILabel(text: nil, textColor: UIColor(hex: 0x333333), fontSize: 16, weight: .semibold)
        titleLabel.text = "You need to pay"
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(178)
            make.centerX.equalToSuperview()
        }

        let countLabel = UILabel(text: nil, textColor: UIColor(hex: 0xE88A27), fontSize: 24, weight: .black)
        countLabel.text = NSNumber(value: attr.csAmt).formatted(style: .decimal)
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(26)
            make.centerX.equalToSuperview().offset(14)
        }

        let tokenView = UIImageView(image: nil)
        if attr.cmdTp == BonusType.gameToken.rawValue {
            tokenView.image = UIImage(named: "img_game_token")
        } else if attr.cmdTp == BonusType.axcToken.rawValue {
            tokenView.image = UIImage(named: "img_axc_token")
        }
        contentView.addSubview(tokenView)
        tokenView.snp.makeConstraints { make in
            make.centerY.equalTo(countLabel)
            make.right.equalTo(countLabel.snp.left).offset(-4)
            make.size.equalTo(26)
        }


        let submitButton = UIButton.primary(title: "OK")
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        contentView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-26)
        }


        let closeButton = UIButton(image: UIImage(named: "img_close"))
        closeButton.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin).offset(-50)
        }
    }


    // MARK: - Private

    private func attributeImage(with type: Int) -> UIImage? {
        switch type {
        case AttributeType.level.rawValue:
            return UIImage(named: "img_profile_level")
        case AttributeType.energy.rawValue:
            return UIImage(named: "img_profile_energy")
        case AttributeType.charge.rawValue:
            return UIImage(named: "img_profile_charge")
        case AttributeType.income.rawValue:
            return UIImage(named: "img_profile_income")
        case AttributeType.lucky.rawValue:
            return UIImage(named: "img_profile_lucky")
        case AttributeType.charm.rawValue:
            return UIImage(named: "img_profile_charm")
        default:
            return UIImage(named: "img_profile_level")
        }
    }

    @objc private func submitButtonClick() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        userProvider.request(.upgradeAttribute(type: attr.atbTp)) { result in
            hud.hide()
            switch result {
            case .success(let response):
                Profile.loadCurrentProfile { _ in  }
                self.presentingViewController?.dismiss(animated: true)
                break
            case .failure(let error):
                ToastView.showToast(error.localizedDescription, in: self.view)
                break
            }
        }
    }

    @objc private func closeButtonClick() {
        presentingViewController?.dismiss(animated: true)
    }

}
