//
// Created by LLL on 2024/3/29.
//

import UIKit

class NFTDurabilityViewController: CommonAlertController {


    var nft: BackpackNFTDetails!
    init(nft: BackpackNFTDetails) {
        super.init(nibName: nil, bundle: nil)
        self.nft = nft
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }


    override func viewDidLoad() {
        title = "Durability"
        addAction(AlertAction(title: "CONFIRM") { [weak self] _ in
            self?.submit()
        })
        super.viewDidLoad()

        let textLabel = UILabel(text: "", textColor: UIColor(hex: 0x804949), fontSize: 20, weight: .bold)
        textLabel.text = "Full repair costs"
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(78)
            make.centerX.equalToSuperview()
        }

        let costLabel = UILabel(text: nil, textColor: UIColor(hex: 0xFF6D3B), fontSize: 24, weight: .heavy)
        costLabel.text = NSNumber(value: nft.durbtyIfo!.csAmt).formatted(style: .decimal)
        contentView.addSubview(costLabel)
        costLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(15)
            make.centerX.equalToSuperview().offset(12)
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
            make.centerY.equalTo(costLabel)
            make.right.equalTo(costLabel.snp.left).offset(-4)
            make.size.equalTo(24)
        }


    }


    private func submit() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        nftProvider.request(.fixDurability(identifier: nft.nftCd)) { result in
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

}
