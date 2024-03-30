//
// Created by LLL on 2024/3/28.
//

import UIKit

class NFTListingViewController: BaseViewController {

    private let priceTF = UITextField()
    private let amountLabel = CustomLabel()

    var nft: BackpackNFTDetails!
    init(nft: BackpackNFTDetails) {
        super.init(nibName: nil, bundle: nil)
        self.nft = nft
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }


    // MARK: - Private

    @objc private func priceTFEditingChange(_ sender: UITextField) {
        guard let price = Double(sender.text!) else { return }
        var amount = price * (1.0 - (nft.slTax / 100.0))
        if nft.slCmdTp == BonusType.axcToken.rawValue {
            amount = Double(Int(amount))
        }
        amountLabel.text = NSNumber(value: amount).formatted(style: .decimal)
    }

    @objc private func submit() {
        guard let price = Double(priceTF.text!) else { return }

        let hud = ProgressHUD.showHUD(addedTo: view)
        nftProvider.request(.startListing(identifier: nft.nftCd, price: price)) { result in
            hud.hide()
            switch result {
            case .success(let response):
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: .BackpackNFTDidChangeNotification, object: nil)
                break
            case .failure(let error):
                ToastView.showToast(error.localizedDescription, in: self.view)
                break
            }
        }
    }

    private func commonInit() {
        title = "List"
        view.layer.contents = UIImage.gradient(colors: [ UIColor(hex: 0xC6B1FF), UIColor(hex: 0xFFEDE0), UIColor(hex: 0xDDC6F6), UIColor(hex: 0x8A8DCF) ], size: view.frame.size, end: CGPoint(x: 0, y: 1)).cgImage

        let topView = UIView()
        topView.backgroundColor = UIColor(hex: 0xCBB6FC)
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        let sectionView = UIImageView()
        sectionView.image = UIImage(named: "img_nft_section_bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 80, left: 170, bottom: 40, right: 170), resizingMode: .stretch)
        sectionView.isUserInteractionEnabled = true
        topView.addSubview(sectionView)
        sectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.topMargin).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-28)
            make.height.equalTo(188)
        }

        let titleLabel = UILabel(text: "List", textColor: .white, fontSize: 20, weight: .bold)
        sectionView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalTo(22)
        }

        priceTF.textColor = UIColor(hex: 0x333333)
        priceTF.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        priceTF.textAlignment = .center
        priceTF.placeholder = "Enter price"
        priceTF.backgroundColor = .white
        priceTF.layer.cornerRadius = 8
        priceTF.layer.masksToBounds = true
        priceTF.keyboardType = .numberPad
        priceTF.addTarget(self, action: #selector(priceTFEditingChange(_:)), for: .editingChanged)
        priceTF.delegate = self
        sectionView.addSubview(priceTF)
        priceTF.snp.makeConstraints { make in
            make.top.equalTo(64)
            make.left.equalTo(22)
            make.right.equalTo(-22)
            make.height.equalTo(56)
        }

        let feeLabel = UILabel(text: "", textColor: UIColor(hex: 0xC63300), fontSize: 12, weight: .bold)
        feeLabel.text = "*Fee: \(nft.slTax)%"
        sectionView.addSubview(feeLabel)
        feeLabel.snp.makeConstraints { make in
            make.top.equalTo(priceTF.snp.bottom).offset(16)
            make.left.equalTo(priceTF)
        }


        let amountTitleLabel = UILabel(text: nil, textColor: UIColor(hex: 0x804949), fontSize: 20, weight: .bold)
        view.addSubview(amountTitleLabel)
        amountTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(42)
            make.centerX.equalToSuperview()
        }

        amountLabel.fonts = CustomLabel.Fonts.gold
        amountLabel.fontSize = 27
        amountLabel.text = "0"
        view.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(amountTitleLabel.snp.bottom).offset(18)
            make.centerX.equalToSuperview().offset(16)
        }

        let tokenView = UIImageView(image: UIImage(named: "img_usdt_token"))
        if nft.slCmdTp == BonusType.axcToken.rawValue {
            tokenView.image = UIImage(named: "img_axc_token")
        }
        view.addSubview(tokenView)
        tokenView.snp.makeConstraints { make in
            make.centerY.equalTo(amountLabel)
            make.right.equalTo(amountLabel.snp.left).offset(-3)
        }

        let submitButton = UIButton.primary(title: "LIST")
        submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(156)
            make.centerX.equalToSuperview()
        }

    }


}


// MARK: - UITextFieldDelegate
extension NFTListingViewController: UITextFieldDelegate {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count > 0 {
            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if let expression = try? NSRegularExpression(pattern: "^([1-9][0-9]*)$") {
                let matches = expression.matches(in: text, range: NSMakeRange(0, text.count))
                return !matches.isEmpty
            }
        }
        return true
    }
}