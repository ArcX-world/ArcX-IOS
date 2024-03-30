//
// Created by LLL on 2024/3/26.
//

import UIKit
import SwiftyJSON

class VendingMachineViewController: BaseViewController {

    private var identifier: String = ""
    private var balance: Double = 0     // 玩家余额USDT
    private var maximum: Double = 0     // 可购买的上限USDT
    private var exchangeRate: Int = 0    // 1USDT与游戏币兑换比例

    private let balanceLabel = UILabel(text: "0", textColor: .white, fontSize: 16, weight: .bold)
    private let amountTF = UITextField()
    private let amountSlider = UISlider()
    private let amountMaximumLabel = UILabel(text: "0", textColor: UIColor(hex: 0x666666), fontSize: 12, weight: .semibold)
    private let identifierLabel = UILabel(text: "#", textColor: UIColor(hex: 0x000000), fontSize: 13, weight: .bold)
    private let priceLabel = UILabel(text: "", textColor: UIColor(hex: 0xE09927), fontSize: 13, weight: .bold)
    private let volumeLabel = UILabel(text: "", textColor: UIColor(hex: 0xFF6D3B), fontSize: 13, weight: .bold)
    private let totalLabel = CustomLabel()


    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        loadData()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if amountTF.isFirstResponder {
            amountTF.resignFirstResponder()
        }
    }


    // MARK: - Private

    private func loadData() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        nftProvider.request(.getVendingMachine) { result in
            hud.hide()
            switch result {
            case .success(let response):
                do {
                    let json = try JSON(data: response.data)

                    self.identifier = json["serverMsg"]["nftCd"].stringValue
                    self.identifierLabel.text = "\(self.identifier)"

                    self.balance = json["serverMsg"]["usdtBl"].doubleValue
                    self.balanceLabel.text = json["serverMsg"]["usdtBl"].numberValue.formatted(style: .decimal)

                    self.maximum = json["serverMsg"]["maxUsdt"].doubleValue
                    self.amountMaximumLabel.text = json["serverMsg"]["maxUsdt"].numberValue.formatted(style: .decimal)
                    self.amountSlider.maximumValue = Float(self.maximum)

                    self.exchangeRate = json["serverMsg"]["usdtExc"].intValue
                    self.priceLabel.text = "1USDT=\(NSNumber(value: self.exchangeRate).formatted(style: .decimal)) coins"

                    self.volumeLabel.text = json["serverMsg"]["maxVl"].numberValue.formatted(style: .decimal)

                } catch {}
                break
            case .failure(let error):
                if let navigationController = self.navigationController {
                    ToastView.showToast(error.localizedDescription, in: navigationController.view)
                    navigationController.popViewController(animated: true)
                }
                break
            }
        }
    }

    @objc private func amountTFEditingChanged(_ sender: UITextField) {
        let text = sender.text!.isEmpty ? "0" : sender.text!
        guard let floatValue = Float(text) else { return }
        if floatValue < amountSlider.maximumValue {
            amountSlider.value = floatValue
        } else {
            amountSlider.value = amountSlider.maximumValue
            sender.text = "\(Int(amountSlider.value))"
        }
        updateUI()
    }

    @objc private func amountSliderValueChange(_ sender: UISlider) {
        amountTF.text = "\(Int(sender.value))"
        updateUI()
    }

    @objc private func submitButtonClick() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        let amount = Int(amountSlider.value)
        nftProvider.request(.exchangeToken(identifier: identifier, usdtAmt: amount, rate: exchangeRate)) { result in
            hud.hide()
            switch result {
            case .success(let response):
                ToastView.showToast("Success!", in: self.view)
                self.loadData()
//                if let navigationController = self.navigationController {
//                    ToastView.showToast("Success!", in: navigationController.view)
//                    navigationController.popViewController(animated: true)
//                }
                break
            case .failure(let error):
                ToastView.showToast(error.localizedDescription, in: self.view)
                break
            }
        }
    }

    private func updateUI() {
        let total = Int(amountSlider.value) * exchangeRate
        totalLabel.text = NSNumber(value: total).formatted(style: .decimal)
    }

    private func commonInit() {
        title = "Sale information"
        view.layer.contents = UIImage.gradient(colors: [ UIColor(hex: 0xC6B1FF), UIColor(hex: 0xFFEDE0), UIColor(hex: 0xDDC6F6), UIColor(hex: 0x8A8DCF)  ], locations: nil, size: view.frame.size, start: CGPoint(), end: CGPoint(x: 0, y: 1)).cgImage

        let topView = UIView()
        topView.backgroundColor = UIColor(hex: 0xCBB6FC)
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        let amountView = UIImageView()
        amountView.image = UIImage(named: "img_vmch_amount_bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 100), resizingMode: .stretch)
        amountView.isUserInteractionEnabled = true
        topView.addSubview(amountView)
        amountView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.topMargin).offset(34)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-26)
        }

        let balanceTitleLabel = UILabel(text: "Balance", textColor: .white, fontSize: 16, weight: .semibold)
        amountView.addSubview(balanceTitleLabel)
        balanceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.left.equalTo(16)
        }

        amountView.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(balanceTitleLabel)
            make.right.equalTo(-16)
        }

        let tokenView = UIImageView(image: UIImage(named: "img_usdt_token"))
        amountView.addSubview(tokenView)
        tokenView.snp.makeConstraints { make in
            make.centerY.equalTo(balanceLabel)
            make.right.equalTo(balanceLabel.snp.left).offset(-2)
        }

        amountTF.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        amountTF.textColor = UIColor(hex: 0x333333)
        amountTF.placeholder = "Pay USDT Amount"
        amountTF.textAlignment = .center
        amountTF.keyboardType = .numberPad
        amountTF.delegate = self
        amountTF.backgroundColor = .white
        amountTF.layer.cornerRadius = 12
        amountTF.layer.masksToBounds = true
        amountTF.addTarget(self, action: #selector(amountTFEditingChanged(_:)), for: .editingChanged)
        amountView.addSubview(amountTF)
        amountTF.snp.makeConstraints { make in
            make.top.equalTo(62)
            make.left.equalTo(22)
            make.right.equalTo(-22)
            make.height.equalTo(56)
        }

        amountSlider.addTarget(self, action: #selector(amountSliderValueChange(_:)), for: .valueChanged)
        amountView.addSubview(amountSlider)
        amountSlider.snp.makeConstraints { make in
            make.top.equalTo(amountTF.snp.bottom).offset(12)
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.bottom.equalTo(-46)
        }

        let amountMinimumLabel = UILabel(text: "0", textColor: UIColor(hex: 0x666666), fontSize: 12, weight: .semibold)
        amountView.addSubview(amountMinimumLabel)
        amountMinimumLabel.snp.makeConstraints { make in
            make.top.equalTo(amountSlider.snp.bottom).offset(2)
            make.left.equalTo(amountSlider.snp.left)
        }

        amountView.addSubview(amountMaximumLabel)
        amountMaximumLabel.snp.makeConstraints { make in
            make.top.equalTo(amountSlider.snp.bottom).offset(2)
            make.right.equalTo(amountSlider.snp.right)
        }


        let infoView = UIView()
        infoView.backgroundColor = .white
        infoView.layer.cornerRadius = 8
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(18)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.greaterThanOrEqualTo(116)
        }

        let identifierTitleLabel = UILabel(text: "Coin Vending NFT", textColor: UIColor(hex: 0x000000), fontSize: 13, weight: .bold)
        infoView.addSubview(identifierTitleLabel)
        identifierTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.left.equalTo(12)
        }

        infoView.addSubview(identifierLabel)
        identifierLabel.snp.makeConstraints { make in
            make.centerY.equalTo(identifierTitleLabel)
            make.right.equalTo(-10)
        }

        let priceTitleLabel = UILabel(text: "Price", textColor: UIColor(hex: 0x000000), fontSize: 13, weight: .bold)
        infoView.addSubview(priceTitleLabel)
        priceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(identifierTitleLabel.snp.bottom).offset(16)
            make.left.equalTo(12)
        }

        infoView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceTitleLabel)
            make.right.equalTo(-10)
        }


        let volumeTitleLabel = UILabel(text: "Max Volume", textColor: UIColor(hex: 0x000000), fontSize: 13, weight: .bold)
        infoView.addSubview(volumeTitleLabel)
        volumeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(priceTitleLabel.snp.bottom).offset(16)
            make.left.equalTo(12)
        }

        infoView.addSubview(volumeLabel)
        volumeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(volumeTitleLabel)
            make.right.equalTo(-10)
        }


        let totalTitleLabel = UILabel(text: "", textColor: UIColor(hex: 0x333333), fontSize: 20, weight: .medium)
        view.addSubview(totalTitleLabel)
        totalTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(26)
            make.centerX.equalToSuperview()
        }


        totalLabel.fonts = CustomLabel.Fonts.gold
        totalLabel.fontSize = 27
        totalLabel.text = "0"
        view.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(totalTitleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview().offset(16)
        }

        let gameTokenView = UIImageView(image: UIImage(named: "img_game_token"))
        view.addSubview(gameTokenView)
        gameTokenView.snp.makeConstraints { make in
            make.centerY.equalTo(totalLabel)
            make.right.equalTo(totalLabel.snp.left).offset(-4)
        }

        let submitButton = UIButton.primary(title: "PAY")
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }

    }

}

// MARK: - UITextFieldDelegate
extension VendingMachineViewController: UITextFieldDelegate {

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