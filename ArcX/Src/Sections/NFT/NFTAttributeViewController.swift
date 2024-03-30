//
// Created by LLL on 2024/3/29.
//

import UIKit

class NFTAttributeViewController: BaseAlertController {

    var nft: BackpackNFTDetails!
    var attr: BackpackNFTDetails.Attribute!

    init(nft: BackpackNFTDetails, attr: BackpackNFTDetails.Attribute) {
        super.init(nibName: nil, bundle: nil)
        self.nft = nft
        self.attr = attr
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }

    // MARK: -

    @objc private func submit() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        nftProvider.request(.upgrade(identifier: nft.nftCd, attrType: attr.atbTp)) { result in
            hud.hide()
            switch result {
            case .success:
                self.presentingViewController?.dismiss(animated: true)
                NotificationCenter.default.post(name: .BackpackNFTDidChangeNotification, object: nil)
                break
            case .failure(let error):
                ToastView.showToast(error.localizedDescription, in: self.view)
                break
            }
        }
    }

    private func commonInit() {

        let contentView = UIImageView(image: UIImage(named: "img_profile_attr_alert"))
        contentView.isUserInteractionEnabled = true
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        let typeView = UIImageView()
        typeView.contentMode = .scaleAspectFit
        contentView.addSubview(typeView)
        typeView.snp.makeConstraints { make in
            make.top.equalTo(19)
            make.centerX.equalToSuperview()
            make.size.equalTo(48)
        }

        let nameView = UIImageView()
        contentView.addSubview(nameView)
        nameView.snp.makeConstraints { make in
            make.top.equalTo(typeView.snp.bottom)
            make.centerX.equalToSuperview()
        }

        if let type = NFTAttributeType(rawValue: attr.atbTp) {
            switch type {
            case .level:
                typeView.image = UIImage(named: "img_nft_level")
                nameView.image = UIImage(named: "img_nft_name_level")
                break
            case .storage:
                typeView.image = UIImage(named: "img_nft_storage")
                nameView.image = UIImage(named: "img_nft_name_space")
                break
            case .discount:
                typeView.image = UIImage(named: "img_nft_discount")
                nameView.image = UIImage(named: "img_nft_name_discount")
                break
            }
        }


        let transferView = UIImageView(image: UIImage(named: "img_profile_attr_transfer"))
        contentView.addSubview(transferView)
        transferView.snp.makeConstraints { make in
            make.top.equalTo(105)
            make.centerX.equalToSuperview()
        }

        let levelLabel = UILabel(text: nil, textColor: .white, fontSize: 20, weight: .heavy)
        levelLabel.text = "LV\(attr.lv)"
        levelLabel.shadowColor = UIColor(hex: 0x000000, alpha: 0.5)
        levelLabel.shadowOffset = CGSize(width: 0, height: 1)
        contentView.addSubview(levelLabel)
        levelLabel.snp.makeConstraints { make in
            make.centerY.equalTo(transferView)
            make.right.equalTo(transferView.snp.left).offset(-8)
        }

        let nextLevelLabel = UILabel(text: nil, textColor: .white, fontSize: 20, weight: .heavy)
        nextLevelLabel.text = "LV\(attr.nxLv)"
        nextLevelLabel.shadowColor = UIColor(hex: 0x000000, alpha: 0.5)
        nextLevelLabel.shadowOffset = CGSize(width: 0, height: 1)
        contentView.addSubview(nextLevelLabel)
        nextLevelLabel.snp.makeConstraints { make in
            make.centerY.equalTo(transferView)
            make.left.equalTo(transferView.snp.right).offset(8)
        }


        let textLabel = UILabel(text: nil, textColor: UIColor(hex: 0x333333), fontSize: 16, weight: .bold)
        textLabel.text = "You need to pay"
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(186)
            make.centerX.equalToSuperview()
        }

        let costLabel = CustomLabel()
        costLabel.fontSize = 27
        costLabel.fonts = CustomLabel.Fonts.gold
        costLabel.text = NSNumber(value: attr.csAmt).formatted(style: .decimal)
        contentView.addSubview(costLabel)
        costLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview().offset(16)
        }

        let tokenView = UIImageView()
        if nft.durbtyIfo!.cmdTp == BonusType.axcToken.rawValue {
            tokenView.image = UIImage(named: "img_axc_token")
        } else if nft.durbtyIfo!.cmdTp == BonusType.usdt.rawValue {
            tokenView.image = UIImage(named: "img_usdt_token")
        } else if nft.durbtyIfo!.cmdTp == BonusType.gameToken.rawValue {
            tokenView.image = UIImage(named: "img_game_token")
        }
        contentView.addSubview(tokenView)
        tokenView.snp.makeConstraints { make in
            make.centerY.equalTo(costLabel).offset(-1)
            make.right.equalTo(costLabel.snp.left).offset(-4)
            make.size.equalTo(30)
        }


        let confirmButton = UIButton.primary(title: "UPGRADE")
        confirmButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        contentView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-38)
        }


        let closeButton = UIButton(image: UIImage(named: "img_close"))
        closeButton.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin).offset(-50)
        }


    }

    @objc private func closeButtonClick() {
        presentingViewController?.dismiss(animated: true)
    }


}
