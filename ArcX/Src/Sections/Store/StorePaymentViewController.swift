//
// Created by LLL on 2024/3/20.
//

import UIKit

class StorePaymentViewController: CommonAlertController {

    var devId: Int?
    var tokenProduct: StoreTokenProduct?
    var propProduct: StorePropProduct?
    var spProduct: StoreSuperPlayer?


    override func viewDidLoad() {
        title = "Pay Confirm"
        addAction(AlertAction(title: "PAY") { [weak self] _ in
            guard let self = self else { return }

            if let tokenProduct = self.tokenProduct {
                self.purchase(with: 2, cmdId: tokenProduct.cmdId)
            }
            else if let propProduct = self.propProduct {
                self.purchase(with: 3, cmdId: propProduct.cmdId)
            }
            else if let spProduct = self.spProduct {
                self.purchase(with: 1, cmdId: nil)
            }
        })
        super.viewDidLoad()

        if let tokenProduct = tokenProduct {
            commonInit(with: tokenProduct)
        }
        else if let propProduct = propProduct {
            commonInit(with: propProduct)
        }
        else if let spProduct = spProduct {
            commonInit(with: spProduct)
        }
    }



    // MARK: - Private

    private func purchase(with type: Int, cmdId: Int?) {
        let hud = ProgressHUD.showHUD(addedTo: view)
        storeProvider.request(.purchase(type: type, cmdId: cmdId, devId: devId)) { result in
            hud.hide()
            switch result {
            case .success(let response):
                ToastView.showToast("Success!", in: self.presentingViewController!.view)
                self.presentingViewController?.dismiss(animated: true)
                break
            case .failure(let error):
                ToastView.showToast(error.localizedDescription, in: self.view)
                break
            }
        }
    }

    private func commonInit(with tokenProduct: StoreTokenProduct) {

        let textLabel = UILabel(text: "", textColor: UIColor(hex: 0x804949), fontSize: 20, weight: .bold)
        textLabel.text = "You are paying"
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(66)
            make.centerX.equalToSuperview()
        }

        let text2Label = UILabel(text: "", textColor: UIColor(hex: 0x804949), fontSize: 20, weight: .bold)
        text2Label.text = "to buy"
        contentView.addSubview(text2Label)
        text2Label.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
        }

        let priceLabel = CustomLabel()
        priceLabel.fontSize = 27
        priceLabel.fonts = CustomLabel.Fonts.gold
        priceLabel.text = NSNumber(value: tokenProduct.usdtAmt).formatted(style: .decimal)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview().offset(15)
        }

        let tokenView = UIImageView(image: UIImage(named: "img_usdt_token"))
        contentView.addSubview(tokenView)
        tokenView.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel)
            make.right.equalTo(priceLabel.snp.left).offset(-4)
            make.size.equalTo(30)
        }

        let countLabel = CustomLabel()
        countLabel.fontSize = 27
        countLabel.fonts = CustomLabel.Fonts.gold
        countLabel.text = NSNumber(value: tokenProduct.cnAmt).formatted(style: .decimal)
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(text2Label.snp.bottom).offset(20)
            make.centerX.equalToSuperview().offset(15)
            make.bottom.lessThanOrEqualTo(buttonsStackView.snp.top).offset(-18)
        }

        let coinsView = UIImageView(image: UIImage(named: "img_game_token"))
        contentView.addSubview(coinsView)
        coinsView.snp.makeConstraints { make in
            make.centerY.equalTo(countLabel)
            make.right.equalTo(countLabel.snp.left).offset(-4)
            make.size.equalTo(30)
        }

    }

    private func commonInit(with propProduct: StorePropProduct) {

        let wrapView = UIView()
        wrapView.backgroundColor = .white
        wrapView.layer.cornerRadius = 12
        wrapView.layer.masksToBounds = true
        contentView.addSubview(wrapView)
        wrapView.snp.makeConstraints { make in
            make.top.equalTo(56)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }

        let propView = UIImageView()
        propView.kf.setImage(with: URL(string: propProduct.pct))
        propView.contentMode = .scaleAspectFit
        wrapView.addSubview(propView)
        propView.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.centerX.equalToSuperview()
            make.size.equalTo(56)
        }

        let descLabel = UILabel(text: propProduct.dsc, textColor: UIColor(hex: 0x333333), fontSize: 14, weight: .heavy)
        descLabel.numberOfLines = 0
        descLabel.lineBreakMode = .byWordWrapping
        descLabel.textAlignment = .center
        wrapView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(propView.snp.bottom).offset(20)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-16)
        }


        let textLabel = UILabel(text: "", textColor: UIColor(hex: 0x804949), fontSize: 20, weight: .bold)
        textLabel.text = "You are paying"
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(wrapView.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
        }

        let priceLabel = CustomLabel()
        priceLabel.fontSize = 27
        priceLabel.fonts = CustomLabel.Fonts.gold
        priceLabel.text = NSNumber(value: propProduct.axcAmt).formatted(style: .decimal)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview().offset(15)
            make.bottom.lessThanOrEqualTo(buttonsStackView.snp.top).offset(-20)
        }

        let tokenView = UIImageView(image: UIImage(named: "img_axc_token"))
        contentView.addSubview(tokenView)
        tokenView.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel)
            make.right.equalTo(priceLabel.snp.left).offset(-4)
            make.size.equalTo(30)
        }

    }

    private func commonInit(with spProduct: StoreSuperPlayer) {

        let textLabel = UILabel(text: "", textColor: UIColor(hex: 0x804949), fontSize: 20, weight: .bold)
        textLabel.text = "You are paying"
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(66)
            make.centerX.equalToSuperview()
        }

        let text2Label = UILabel(text: "", textColor: UIColor(hex: 0x804949), fontSize: 20, weight: .bold)
        text2Label.numberOfLines = 0
        text2Label.lineBreakMode = .byWordWrapping
        text2Label.attributedText = NSAttributedString(string: "to buy\nsuper player", attributes: [
            .paragraphStyle: NSMutableParagraphStyle().then {
                $0.lineSpacing = 13
                $0.alignment = .center
            }
        ])
        contentView.addSubview(text2Label)
        text2Label.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(68)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualTo(buttonsStackView.snp.top).offset(-20)
        }

        let priceLabel = CustomLabel()
        priceLabel.fontSize = 27
        priceLabel.fonts = CustomLabel.Fonts.gold
        priceLabel.text = NSNumber(value: spProduct.usdtAmt).formatted(style: .decimal)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview().offset(15)
        }

        let tokenView = UIImageView(image: UIImage(named: "img_usdt_token"))
        contentView.addSubview(tokenView)
        tokenView.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel)
            make.right.equalTo(priceLabel.snp.left).offset(-4)
            make.size.equalTo(30)
        }

    }



}
