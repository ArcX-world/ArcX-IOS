//
// Created by LLL on 2024/3/29.
//

import UIKit

class NFTSalesViewController: BaseViewController {

    private let amountTF = UITextField()
    private let popupView = UIImageView()
    private let discountLabel = UILabel(text: nil, textColor: UIColor(hex: 0x333333), fontSize: 14, weight: .bold)


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

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if !popupView.isHidden {
            popupView.isHidden = true
        }
    }

    // MARK: -

    @objc private func amountTFEditingChange(_ sender: UITextField) {
        guard let price = Double(amountTF.text!) else { return }

        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.minimumFractionDigits = 0
        fmt.maximumFractionDigits = 2

        let discount = (1.0 - nft.gdIfo!.oriAmt / (price * 1000000.0)) * 100
        let discountString = fmt.string(from: NSNumber(value: discount))! + "%"
        discountLabel.attributedText = NSMutableAttributedString(string: discountString, attributes: [ .foregroundColor: UIColor(hex: 0xFF6D3B) ]).then {
            $0.append(NSAttributedString(string: " discount than official price"))
        }
    }

    @objc private func helpButtonClick() {
        popupView.isHidden = false
    }

    @objc private func submit() {
        guard let price = Double(amountTF.text!) else { return }

        let hud = ProgressHUD.showHUD(addedTo: view)
        nftProvider.request(.startSales(identifier: nft.nftCd, price: price * 1000000.0)) { result in
            hud.hide()
            switch result {
            case .success:
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
        title = "Sale"
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
            make.height.equalTo(150)
        }

        let titleLabel = UILabel(text: "", textColor: .white, fontSize: 16, weight: .bold)
        titleLabel.text = "Amount of game coins per 1USDT"
        sectionView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(22)
        }

        amountTF.textColor = UIColor(hex: 0x333333)
        amountTF.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        amountTF.textAlignment = .center
        amountTF.placeholder = "Enter 1 or more"
        amountTF.backgroundColor = .white
        amountTF.layer.cornerRadius = 8
        amountTF.layer.masksToBounds = true
        amountTF.keyboardType = .numberPad
        amountTF.addTarget(self, action: #selector(amountTFEditingChange(_:)), for: .editingChanged)
        amountTF.delegate = self
        sectionView.addSubview(amountTF)
        amountTF.snp.makeConstraints { make in
            make.top.equalTo(66)
            make.left.equalTo(24)
            make.right.equalTo(-72)
            make.height.equalTo(56)
        }

        let millionLabel = UILabel(text: "Million", textColor: UIColor(hex: 0xFF6D3B), fontSize: 14, weight: .bold)
        sectionView.addSubview(millionLabel)
        millionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(amountTF)
            make.left.equalTo(amountTF.snp.right).offset(10)
        }


        let infoView = UIView()
        infoView.backgroundColor = .white
        infoView.layer.cornerRadius = 8
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.greaterThanOrEqualTo(84)
        }

        infoView.addSubview(discountLabel)
        discountLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.left.equalTo(16)
        }

        let discountString = NSMutableAttributedString(string: " discount than official price")
        discountString.insert(NSAttributedString(string: "0%", attributes: [ .foregroundColor: UIColor(hex: 0xFF6D3B) ]), at: 0)
        discountLabel.attributedText = discountString

        let taxTitleLabel = UILabel(text: nil, textColor: UIColor(hex: 0x333333), fontSize: 14, weight: .bold)
        taxTitleLabel.text = "Current sales tax rate"
        infoView.addSubview(taxTitleLabel)
        taxTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(discountLabel.snp.bottom).offset(12)
            make.left.equalTo(16)
        }

        let taxLabel = UILabel(text: nil, textColor: UIColor(hex: 0xFF6D3B), fontSize: 14, weight: .bold)
        taxLabel.text = NSNumber(value: nft.slTax).formatted(style: .decimal) + "%"
        infoView.addSubview(taxLabel)
        taxLabel.snp.makeConstraints { make in
            make.centerY.equalTo(taxTitleLabel)
            make.right.equalTo(-40)
        }

        let helpButton = UIButton(image: UIImage(named: "img_nft_help"))
        helpButton.addTarget(self, action: #selector(helpButtonClick), for: .touchUpInside)
        infoView.addSubview(helpButton)
        helpButton.snp.makeConstraints { make in
            make.centerY.equalTo(taxLabel)
            make.right.equalTo(-10)
        }


        popupView.image = UIImage(named: "img_nft_popup")
        popupView.isHidden = true
        view.addSubview(popupView)
        popupView.snp.makeConstraints { make in
            make.top.equalTo(helpButton.snp.bottom).offset(-3)
            make.right.equalTo(-16)
            make.size.equalTo(popupView.image!.size)
        }


        let tipsLabel = UILabel(text: nil, textColor: UIColor(hex: 0xFFFFFF), fontSize: 10, weight: .semibold)
        tipsLabel.text = "Inviting friends to become a super player can reduce the tax rate."
        tipsLabel.lineBreakMode = .byWordWrapping
        tipsLabel.numberOfLines = 0
        popupView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }


        let confirmButton = UIButton.primary(title: "START SALE")
        confirmButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
        }


    }


}

// MARK: - UITextFieldDelegate
extension NFTSalesViewController: UITextFieldDelegate {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count > 0 {
            let text = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if let expression = try? NSRegularExpression(pattern: "^\\d+(?:\\.|\\.\\d{1,4})?$") {
                let matches = expression.matches(in: text, range: NSMakeRange(0, text.count))
                return !matches.isEmpty
            }
        }
        return true
    }
}