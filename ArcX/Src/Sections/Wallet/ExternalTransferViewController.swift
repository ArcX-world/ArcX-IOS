//
// Created by LLL on 2024/3/23.
//

import UIKit
import SwiftyJSON

class ExternalTransferViewController: BaseViewController {

    var token: WalletToken = .usdt
    var balanceMap: [WalletToken: Double] = [:]
    var minimumMap: [WalletToken: Double] = [:]

    private let tokenButton = UIButton(type: .custom)
    private let tokenView = UIImageView()
    private let addressTF = UITextField()
    private let amountTF = UITextField()
    private let amountUnitLabel = UILabel(text: "", textColor: UIColor(hex: 0x333333), fontSize: 16, weight: .medium)
    private let balanceLabel = UILabel(text: "", textColor: UIColor(hex: 0x333333), fontSize: 16, weight: .bold)
    private let feeLabel = UILabel(text: "", textColor: UIColor(hex: 0x666666), fontSize: 12, weight: .bold)
    private let minimumLabel = UILabel(text: "", textColor: UIColor(hex: 0x666666), fontSize: 12, weight: .bold)


    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        updateUI()
        loadConfiguration()
    }



    // MARK: - Private

    private func loadConfiguration() {
        walletProvider.request(.getConfiguration) { result in
            switch result {
            case .success(let response):
                do {
                    let json = try JSON(data: response.data)
                    self.feeLabel.text = json["serverMsg"]["exFee"].string

                    for token in WalletToken.allValues {
                        self.minimumMap[token] = json["serverMsg"]["minIfo"][token.unit.lowercased()].doubleValue
                    }
                    self.updateUI()

                } catch {}
                break
            case .failure:
                break
            }
        }
    }

    @objc private func tokenButtonClick() {
        let pickerController = TokenPickerController()
        pickerController.onSelect = { [weak self] token in
            guard let self = self else { return }
            self.token = token
            self.updateUI()
        }
        present(pickerController, animated: true)
    }

    @objc private func scanButtonClick() {
        let scannerController = WalletScannerController()
        scannerController.resultBlock = { [weak self] address in
            guard let self = self else { return }
            self.addressTF.text = address
        }
        show(scannerController, sender: nil)
    }

    @objc private func putAllButtonClick() {
        let balance = balanceMap[token] ?? 0
        amountTF.text = NSNumber(value: balance).formatted(style: .none)
    }

    @objc private func submitButtonClick() {
        if amountTF.text!.isEmpty { return }
        guard let doubleValue = Double(amountTF.text!) else { return }
    }

    private func updateUI() {

        tokenView.image = UIImage(named: "img_\(token.unit.lowercased())_token")
        tokenButton.setTitle(token.unit, for: .normal)
        amountUnitLabel.text = token.unit

        let balance = balanceMap[token] ?? 0
        balanceLabel.text = "\(NSNumber(value: balance).formatted(style: .decimal)) \(token.unit)"

        let minimum = minimumMap[token] ?? 0
        minimumLabel.text = "\(NSNumber(value: minimum).formatted(style: .decimal)) \(token.unit)"

    }

    private func commonInit() {
        title = "To external"
        view.layer.contents = UIImage.gradient(colors: [ UIColor(hex: 0xC6B1FF), UIColor(hex: 0xFFEDE0), UIColor(hex: 0xDDC6F6), UIColor(hex: 0x8A8DCF)  ], locations: nil, size: view.frame.size, start: CGPoint(), end: CGPoint(x: 0, y: 1)).cgImage

        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(scrollView)

        let contentView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 812))
        scrollView.addSubview(contentView)

        let topView = UIView()
        topView.backgroundColor = UIColor(hex: 0xCBB6FC)
        contentView.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        let sendView = UIView()
        sendView.backgroundColor = .white
        sendView.layer.cornerRadius = 16
        topView.addSubview(sendView)
        sendView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.topMargin).offset(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-26)
            make.height.equalTo(126)
        }

        let sendLabel = UILabel(text: "SEND TO", textColor: UIColor(hex: 0x333333), fontSize: 16, weight: .medium)
        sendView.addSubview(sendLabel)
        sendLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.centerX.equalToSuperview()
        }

        tokenButton.setBackgroundImage(UIImage.pure(color: UIColor(hex: 0xE0D7F8), size: CGSize(width: 300, height: 56), cornerRadius: 8), for: .normal)
        tokenButton.setImage(UIImage.pure(color: UIColor(hex: 0x172038), size: CGSize(width: 36, height: 36), cornerRadius: 16), for: .normal)
        tokenButton.setTitleColor(UIColor(hex: 0x333333), for: .normal)
        tokenButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        tokenButton.contentHorizontalAlignment = .left
        tokenButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        tokenButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
        tokenButton.addTarget(self, action: #selector(tokenButtonClick), for: .touchUpInside)
        sendView.addSubview(tokenButton)
        tokenButton.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.bottom.equalTo(-16)
        }


        tokenButton.addSubview(tokenView)
        tokenView.snp.makeConstraints { make in
            make.center.equalTo(tokenButton.imageView!)
            make.size.equalTo(32)
        }


        let arrowView = UIImageView(image: UIImage(named: "img_wallet_arrow_right"))
        tokenButton.addSubview(arrowView)
        arrowView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-8)
        }


        let addressLabel = UILabel(text: "To address", textColor: UIColor(hex: 0x333333), fontSize: 16, weight: .bold)
        contentView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.left.equalTo(16)
        }

        let addressView = UIView()
        addressView.backgroundColor = .white
        addressView.layer.cornerRadius = 8
        addressView.layer.masksToBounds = true
        contentView.addSubview(addressView)
        addressView.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(8)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(44)
        }

        addressTF.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        addressTF.textColor = UIColor(hex: 0x333333)
        addressTF.placeholder = ""
        addressTF.keyboardType = .default
        addressView.addSubview(addressTF)
        addressTF.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(10)
            make.right.equalTo(-50)
        }

        let scanButton = UIButton(image: UIImage(named: "img_wallet_scan"))
        scanButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
        scanButton.addTarget(self, action: #selector(scanButtonClick), for: .touchUpInside)
        addressView.addSubview(scanButton)
        scanButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
        }


        let amountLabel = UILabel(text: "Amount", textColor: UIColor(hex: 0x333333), fontSize: 16, weight: .bold)
        view.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(addressView.snp.bottom).offset(16)
            make.left.equalTo(16)
        }

        let amountView = UIView()
        amountView.backgroundColor = .white
        amountView.layer.cornerRadius = 8
        amountView.layer.masksToBounds = true
        contentView.addSubview(amountView)
        amountView.snp.makeConstraints { make in
            make.top.equalTo(amountLabel.snp.bottom).offset(8)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(44)
        }

        amountTF.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        amountTF.textColor = UIColor(hex: 0x333333)
        amountTF.placeholder = ""
        amountTF.keyboardType = .numberPad
        amountView.addSubview(amountTF)
        amountTF.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(10)
            make.right.equalTo(-80)
        }

        let putAllButton = UIButton.plain(title: "ALL", titleColor: UIColor(hex: 0xFF6D3B), fontSize: 14, weight: .bold)
        putAllButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 12)
        putAllButton.addTarget(self, action: #selector(putAllButtonClick), for: .touchUpInside)
        amountView.addSubview(putAllButton)
        putAllButton.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
        }

        amountView.addSubview(amountUnitLabel)
        amountUnitLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(putAllButton.snp.left).offset(-2)
        }

        let balanceTitleLabel = UILabel(text: "Balance: ", textColor: UIColor(hex: 0x333333), fontSize: 16, weight: .bold)
        contentView.addSubview(balanceTitleLabel)
        balanceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(amountView.snp.bottom).offset(12)
            make.left.equalTo(16)
        }

        contentView.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.left.equalTo(balanceTitleLabel.snp.right).offset(4)
            make.centerY.equalTo(balanceTitleLabel)
        }


        let tipsView = UIView()
        tipsView.backgroundColor = .white
        tipsView.layer.cornerRadius = 8
        tipsView.layer.masksToBounds = true
        contentView.addSubview(tipsView)
        tipsView.snp.makeConstraints { make in
            make.top.equalTo(balanceTitleLabel.snp.bottom).offset(6)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }

        let tipsLabel = UILabel(text: nil, textColor: UIColor(hex: 0x666666), fontSize: 10, weight: .semibold)
        tipsLabel.numberOfLines = 0
        tipsLabel.lineBreakMode = .byWordWrapping
        tipsView.addSubview(tipsLabel)
        tipsLabel.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12))
        }

        let tipsText = "The network you have selected is Solana. Please ensure that the withdrawal address supports the Solana network. You will lose your assets if the chosen platform does not support retrievals."
        let tipsString = NSMutableAttributedString(string: tipsText, attributes: [
            .paragraphStyle: NSMutableParagraphStyle().then {
                $0.lineSpacing = 3
            }
        ])
        do {
            let expression = try NSRegularExpression(pattern: "Solana")
            let matches = expression.matches(in: tipsString.string, range: NSMakeRange(0, tipsString.string.count))
            for match in matches {
                tipsString.addAttribute(.foregroundColor, value: UIColor(hex: 0xF84343), range: match.range)
            }

            let range = (tipsString.string as NSString).range(of: "You will lose your assets")
            tipsString.addAttribute(.foregroundColor, value: UIColor(hex: 0xF84343), range: range)

        } catch {}

        tipsLabel.attributedText = tipsString



        let infoView = UIView()
        infoView.backgroundColor = .white
        infoView.layer.cornerRadius = 8
        infoView.layer.masksToBounds = true
        contentView.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(tipsView.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(100)
        }

        let networkTitleLabel = UILabel(text: "Network", textColor: UIColor(hex: 0x333333), fontSize: 13, weight: .bold)
        infoView.addSubview(networkTitleLabel)
        networkTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(14)
            make.left.equalTo(10)
        }

        let networkLabel = UILabel(text: "Solana", textColor: UIColor(hex: 0x666666), fontSize: 12, weight: .bold)
        infoView.addSubview(networkLabel)
        networkLabel.snp.makeConstraints { make in
            make.centerY.equalTo(networkTitleLabel)
            make.right.equalTo(-10)
        }

        let feeTitleLabel = UILabel(text: "Network fee", textColor: UIColor(hex: 0x333333), fontSize: 13, weight: .bold)
        infoView.addSubview(feeTitleLabel)
        feeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(networkTitleLabel.snp.bottom).offset(12)
            make.left.equalTo(10)
        }

        infoView.addSubview(feeLabel)
        feeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(feeTitleLabel)
            make.right.equalTo(-10)
        }

        let minimumTitleLabel = UILabel(text: "Minimum withdraw", textColor: UIColor(hex: 0x333333), fontSize: 13, weight: .bold)
        infoView.addSubview(minimumTitleLabel)
        minimumTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(feeTitleLabel.snp.bottom).offset(12)
            make.left.equalTo(10)
        }

        infoView.addSubview(minimumLabel)
        minimumLabel.snp.makeConstraints { make in
            make.centerY.equalTo(minimumTitleLabel)
            make.right.equalTo(-10)
        }


        let submitButton = UIButton.primary(title: "CONFIRM")
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        contentView.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }

    }

}
