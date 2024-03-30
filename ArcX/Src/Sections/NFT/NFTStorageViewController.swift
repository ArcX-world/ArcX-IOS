//
// Created by LLL on 2024/3/28.
//

import UIKit

class NFTStorageViewController: BaseViewController {

    private let countTF = UITextField()
    private let countSlider = UISlider()
    private let amountLabel = UILabel(text: "", textColor: UIColor(hex: 0x000000), fontSize: 13, weight: .bold)
    private let originalLabel = UILabel(text: "", textColor: UIColor(hex: 0x999999), fontSize: 13, weight: .bold)
    private let discountLabel = UILabel(text: "", textColor: UIColor(hex: 0xFF6D3B), fontSize: 13, weight: .bold)
    private let costLabel = UILabel(text: "", textColor: UIColor(hex: 0x0EBF63), fontSize: 13, weight: .bold)


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
        updateUI()
    }


    // MARK: - Private


    @objc private func countTFEditingChange(_ sender: UITextField) {
        guard let value = Float(sender.text!) else { return }
        if value < countSlider.maximumValue {
            countSlider.value = countSlider.minimumValue + value
        } else {
            sender.text = NSNumber(value: countSlider.maximumValue).formatted(style: .decimal)
            countSlider.value = countSlider.maximumValue
        }
        updateUI()
    }

    @objc private func countSliderValueChange(_ sender: UISlider) {
        if sender.value != 1.0 {
            let million: Float = 1000000.0
            var val = sender.value * Float(nft.gdIfo!.upGdAmt)
            val = Float(Int(val / million)) * million
            countTF.text = NSNumber(value: val).formatted(style: .decimal)
            sender.value = val / Float(nft.gdIfo!.upGdAmt)
        } else {
            countTF.text = NSNumber(value: nft.gdIfo!.upGdAmt).formatted(style: .decimal)
        }
        updateUI()
    }

    @objc private func submit() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        let amount = Int64(countSlider.value - countSlider.minimumValue)
        nftProvider.request(.upgradeStorage(identifier: nft.nftCd, amount: amount)) { result in
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


    private func updateUI() {
        let amount = Float(nft.gdIfo!.cnGdAmt) + countSlider.value * Float(nft.gdIfo!.upGdAmt)
        amountLabel.text = NSNumber(value: amount).formatted(style: .decimal)

        let usdt = Double(countSlider.value) * Double(nft.gdIfo!.upGdAmt) / nft.gdIfo!.oriAmt
        let originalString = NSNumber(value: usdt).formatted(style: .decimal) + " USDT"
        originalLabel.attributedText = NSAttributedString(string: originalString, attributes: [
            .strikethroughColor: UIColor(hex: 0x999999),
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
        ])

        let cost = usdt * (1.0 - (nft.gdIfo!.dscot / 100))
        costLabel.text = NSNumber(value: cost).formatted(style: .decimal) + " USDT"
    }

    private func commonInit() {
        title = "Coin add"
        view.layer.contents = UIImage.gradient(colors: [UIColor(hex: 0xC6B1FF), UIColor(hex: 0xFFEDE0), UIColor(hex: 0xDDC6F6), UIColor(hex: 0x8A8DCF)], size: view.frame.size, end: CGPoint(x: 0, y: 1)).cgImage

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

        let titleLabel = UILabel(text: "Balance", textColor: .white, fontSize: 20, weight: .bold)
        sectionView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalTo(22)
        }

        let balanceLabel = UILabel(text: nil, textColor: .white, fontSize: 16, weight: .heavy)
        balanceLabel.text = NSNumber(value: nft.gdIfo!.cnGdAmt).formatted(style: .decimal)
        sectionView.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(-16)
        }

        let coinView = UIImageView(image: UIImage(named: "img_game_token"))
        sectionView.addSubview(coinView)
        coinView.snp.makeConstraints { make in
            make.centerY.equalTo(balanceLabel)
            make.right.equalTo(balanceLabel.snp.left).offset(-2)
            make.size.equalTo(20)
        }


        countTF.text = "0"
        countTF.textColor = UIColor(hex: 0x333333)
        countTF.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        countTF.textAlignment = .center
        countTF.placeholder = "Enter coins"
        countTF.backgroundColor = .white
        countTF.layer.cornerRadius = 8
        countTF.layer.masksToBounds = true
        countTF.keyboardType = .numberPad
        countTF.isEnabled = false
        //countTF.addTarget(self, action: #selector(countTFEditingChange(_:)), for: .editingChanged)
        countTF.delegate = self
        sectionView.addSubview(countTF)
        countTF.snp.makeConstraints { make in
            make.top.equalTo(64)
            make.left.equalTo(22)
            make.right.equalTo(-22)
            make.height.equalTo(56)
        }


        let minimum = NSNumber(value: nft.gdIfo!.cnGdAmt)
        let maximum = NSNumber(value: nft.gdIfo!.cnGdAmt + nft.gdIfo!.upGdAmt)


        countSlider.value = 0
        countSlider.minimumValue = 0
        countSlider.maximumValue = 1
        countSlider.addTarget(self, action: #selector(countSliderValueChange(_:)), for: .valueChanged)
        countSlider.sizeToFit()
        sectionView.addSubview(countSlider)
        countSlider.snp.makeConstraints { make in
            make.top.equalTo(countTF.snp.bottom).offset(6)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(countSlider.frame.height)
        }

        let countMinimumLabel = UILabel(text: "0", textColor: UIColor(hex: 0x666666), fontSize: 12, weight: .semibold)
        //countMinimumLabel.text = minimum.formatted(style: .decimal)
        sectionView.addSubview(countMinimumLabel)
        countMinimumLabel.snp.makeConstraints { make in
            make.top.equalTo(countSlider.snp.bottom).offset(2)
            make.left.equalTo(countSlider.snp.left)
        }

        let countMaximumLabel = UILabel(text: nil, textColor: UIColor(hex: 0x666666), fontSize: 12, weight: .semibold)
        //countMaximumLabel.text = maximum.formatted(style: .decimal)
        countMaximumLabel.text = NSNumber(value: nft.gdIfo!.upGdAmt).formatted(style: .decimal)
        sectionView.addSubview(countMaximumLabel)
        countMaximumLabel.snp.makeConstraints { make in
            make.top.equalTo(countSlider.snp.bottom).offset(2)
            make.right.equalTo(countSlider.snp.right)
        }



        let infoView = UIView()
        infoView.backgroundColor = .white
        infoView.layer.cornerRadius = 8
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.greaterThanOrEqualTo(148)
        }


        let changeTitleLabel = UILabel(text: "Coin changes", textColor: UIColor(hex: 0x000000), fontSize: 13, weight: .bold)
        infoView.addSubview(changeTitleLabel)
        changeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.left.equalTo(12)
        }

        let originalTitleLabel = UILabel(text: "Original price", textColor: UIColor(hex: 0x000000), fontSize: 13, weight: .bold)
        infoView.addSubview(originalTitleLabel)
        originalTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(changeTitleLabel.snp.bottom).offset(16)
            make.left.equalTo(12)
        }

        let discountTitleLabel = UILabel(text: "Discount", textColor: UIColor(hex: 0x000000), fontSize: 13, weight: .bold)
        infoView.addSubview(discountTitleLabel)
        discountTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(originalTitleLabel.snp.bottom).offset(16)
            make.left.equalTo(12)
        }

        let costTitleLabel = UILabel(text: "Cost", textColor: UIColor(hex: 0x000000), fontSize: 13, weight: .bold)
        infoView.addSubview(costTitleLabel)
        costTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(discountTitleLabel.snp.bottom).offset(16)
            make.left.equalTo(12)
        }


        infoView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(changeTitleLabel)
            make.right.equalTo(-12)
        }

        infoView.addSubview(originalLabel)
        originalLabel.snp.makeConstraints { make in
            make.centerY.equalTo(originalTitleLabel)
            make.right.equalTo(-12)
        }

        discountLabel.text = NSNumber(value: nft.gdIfo!.dscot).formatted(style: .decimal) + "%"
        infoView.addSubview(discountLabel)
        discountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(discountTitleLabel)
            make.right.equalTo(-12)
        }

        infoView.addSubview(costLabel)
        costLabel.snp.makeConstraints { make in
            make.centerY.equalTo(costTitleLabel)
            make.right.equalTo(-12)
        }


        let confirmButton = UIButton.primary(title: "CONFIRM")
        confirmButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
        }


    }


}


// MARK: - UITextFieldDelegate
extension NFTStorageViewController: UITextFieldDelegate {

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count > 0 {
            if let expression = try? NSRegularExpression(pattern: "^([1-9][0-9]*)$") {
                let matches = expression.matches(in: string, range: NSMakeRange(0, string.count))
                return !matches.isEmpty
            }
        }
        return true
    }
}