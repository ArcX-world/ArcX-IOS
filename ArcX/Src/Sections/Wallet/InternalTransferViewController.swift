//
// Created by LLL on 2024/3/22.
//

import UIKit
import SwiftyJSON


class WalletInternalTransferViewController: BaseViewController {

    enum Method {
        case spending2Wallet
        case wallet2Spending
    }

    var method: Method = .spending2Wallet
    var token: WalletToken = .axc
    var balanceMap: [WalletToken: Double] = [:]


    private let tokenView = UIImageView()
    private let tokenNameLabel = UILabel(text: nil, textColor: UIColor(hex: 0x333333), fontSize: 13, weight: .bold)
    private let amountTF = UITextField()
    private let balanceLabel = UILabel(text: "0", textColor: UIColor(hex: 0x666666), fontSize: 12, weight: .bold)
    private let feeLabel = UILabel(text: "", textColor: UIColor(hex: 0x666666), fontSize: 12, weight: .bold)
    private let maximumLabel = UILabel(text: "", textColor: UIColor(hex: 0x666666), fontSize: 12, weight: .bold)


    init(method: Method, token: WalletToken) {
        super.init(nibName: nil, bundle: nil)
        self.method = method
        self.token = token
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        updateUI()
        //loadWallet()
        loadConfiguration()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if amountTF.isFirstResponder {
            amountTF.resignFirstResponder()
        }
    }

    // MARK: - Private

    private func loadWallet() {
        switch method {
        case .spending2Wallet:
            walletProvider.request(.getSpendingWallet) { result in
                switch result {
                case .success(let response):
                    do {
                        let json = try JSON(data: response.data)
                        for token in WalletToken.allValues {
                            self.balanceMap[token] = json["serverMsg"][token.unit.lowercased()].doubleValue
                        }
                        self.updateUI()
                    } catch {}
                    break
                case .failure(let error):
                    ToastView.showToast(error.localizedDescription, in: self.view)
                    break
                }
            }
            break
        case .wallet2Spending:
            walletProvider.request(.getBlockchainWallet) { result in
                switch result {
                case .success(let response):
                    do {
                        let json = try JSON(data: response.data)
                        for token in WalletToken.allValues {
                            self.balanceMap[token] = json["serverMsg"][token.unit.lowercased()].doubleValue
                        }
                        self.updateUI()
                    } catch { }
                    break
                case .failure(let error):
                    ToastView.showToast(error.localizedDescription, in: self.view)
                    break
                }
            }
            break
        }
    }

    private func loadConfiguration() {
        walletProvider.request(.getConfiguration) { result in
            switch result {
            case .success(let response):
                do {
                    let maximum = try response.map(Double.self, atKeyPath: "serverMsg.maxIfo.\(self.token.unit.lowercased())")
                    let fee = try response.map(Double.self, atKeyPath: "serverMsg.feeIfo.\(self.token.unit.lowercased())")

                    let fmt = NumberFormatter()
                    fmt.numberStyle = .decimal
                    fmt.minimumFractionDigits = 0
                    fmt.maximumFractionDigits = 9
                    self.maximumLabel.text = "\(fmt.string(from: NSNumber(value: maximum))!) \(self.token.unit)"
                    self.feeLabel.text = "\(fmt.string(from: NSNumber(value: fee))!) \(self.token.unit)"

                } catch { print(error) }
                break
            case .failure:
                break
            }
        }
    }

    private func transferWallet(with tokenType: Int, amount: Double) {
        let hud = ProgressHUD.showHUD(addedTo: view)
        walletProvider.request(.transferWallet(tokenType: tokenType, amount: amount)) { result in
            hud.hide()
            switch result {
            case .success(let response):
                self.loadWallet()
                NotificationCenter.default.post(name: .WalletDidChangeNotification, object: nil)
                ToastView.showToast("Success", in: self.view)
                self.amountTF.text = nil
                break
            case .failure(let error):
                ToastView.showToast(error.localizedDescription, in: self.view)
                break
            }
        }
    }

    private func transferSpending(with tokenType: Int, amount: Double) {
        let hud = ProgressHUD.showHUD(addedTo: view)
        walletProvider.request(.transferSpending(tokenType: tokenType, amount: amount)) { result in
            hud.hide()
            switch result {
            case .success(let response):
                do {
                    let url = try response.map(String.self, atKeyPath: "serverMsg.url")
                    self.show(TransactionConsentViewController(url: url), sender: nil)
                } catch {}
                break
            case .failure(let error):
                ToastView.showToast(error.localizedDescription, in: self.view)
                break
            }
        }
    }


    @objc private func assetViewTap() {
        let pickerController = TokenPickerController()
        pickerController.onSelect = { [weak self] token in
            guard let self = self else { return }
            self.token = token
            self.updateUI()
        }
        present(pickerController, animated: true)
    }

    @objc private func putAllButtonClick() {
        let balance = balanceMap[token] ?? 0
        amountTF.text = "\(NSNumber(value: balance).intValue)"
    }

    @objc private func submitButtonClick() {
        if amountTF.text!.isEmpty { return }
        guard let doubleValue = Double(amountTF.text!) else { return }

        switch method {
        case .spending2Wallet:
            transferWallet(with: token.rawValue, amount: doubleValue)
        case .wallet2Spending:
            transferSpending(with: token.rawValue, amount: doubleValue)
        }

    }

    private func updateUI() {
        tokenView.image = token.icon
        tokenNameLabel.text = token.unit
        let balance = balanceMap[token] ?? 0
        balanceLabel.text = NSNumber(value: balance).formatted(style: .decimal) + " \(token.unit)"
    }

    private func commonInit() {

        let fromWallet: String
        let toWallet: String
        switch method {
        case .spending2Wallet:
            title = "Withdraw"
            fromWallet = "Spending"
            toWallet = "Wallet"
        case .wallet2Spending:
            title = "Spending"
            fromWallet = "Wallet"
            toWallet = "Spending"
        }


        view.layer.contents = UIImage.gradient(colors: [ UIColor(hex: 0xC6B1FF), UIColor(hex: 0xFFEDE0), UIColor(hex: 0xDDC6F6), UIColor(hex: 0x8A8DCF)  ], locations: nil, size: view.frame.size, start: CGPoint(), end: CGPoint(x: 0, y: 1)).cgImage

        let topView = UIView()
        topView.backgroundColor = UIColor(hex: 0xCBB6FC)
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        let flowView = UIImageView()
        flowView.image = UIImage(named: "img_wallet_transfer")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 220, bottom: 0, right: 50), resizingMode: .stretch)
        topView.addSubview(flowView)
        flowView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.topMargin)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(-26)
        }

        let fromLabel = UILabel(text: fromWallet, textColor: UIColor(hex: 0x666666), fontSize: 16, weight: .semibold)
        flowView.addSubview(fromLabel)
        fromLabel.snp.makeConstraints { make in
            make.top.equalTo(26)
            make.right.equalTo(-20)
        }

        let toLabel = UILabel(text: toWallet, textColor: UIColor(hex: 0x666666), fontSize: 16, weight: .semibold)
        flowView.addSubview(toLabel)
        toLabel.snp.makeConstraints { make in
            make.top.equalTo(104)
            make.right.equalTo(-20)
        }

        let assetLabel = UILabel(text: "Asset", textColor: UIColor(hex: 0x333333), fontSize: 16, weight: .bold)
        view.addSubview(assetLabel)
        assetLabel.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(22)
            make.left.equalTo(16)
        }

        let assetView = UIView()
        assetView.backgroundColor = .white
        assetView.layer.cornerRadius = 8
        assetView.layer.masksToBounds = true
        assetView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(assetViewTap)))
        view.addSubview(assetView)
        assetView.snp.makeConstraints { make in
            make.top.equalTo(assetLabel.snp.bottom).offset(8)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(44)
        }

        let tokenBgView = UIView()
        tokenBgView.backgroundColor = UIColor(hex: 0x172038)
        tokenBgView.layer.cornerRadius = 18
        tokenBgView.layer.masksToBounds = true
        assetView.addSubview(tokenBgView)
        tokenBgView.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(36)
        }

        tokenBgView.addSubview(tokenView)
        tokenView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
        }

        assetView.addSubview(tokenNameLabel)
        tokenNameLabel.snp.makeConstraints { make in
            make.left.equalTo(tokenBgView.snp.right).offset(6)
            make.centerY.equalToSuperview()
        }

        let arrowView = UIImageView(image: UIImage(named: "img_wallet_arrow_right"))
        assetView.addSubview(arrowView)
        arrowView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-20)
        }


        let amountLabel = UILabel(text: "Amount", textColor: UIColor(hex: 0x333333), fontSize: 16, weight: .bold)
        view.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(assetView.snp.bottom).offset(16)
            make.left.equalTo(16)
        }

        let amountView = UIView()
        amountView.backgroundColor = .white
        amountView.layer.cornerRadius = 8
        amountView.layer.masksToBounds = true
        view.addSubview(amountView)
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
        amountTF.delegate = self
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


        view.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(amountLabel)
            make.right.equalTo(-16)
        }


        if method == .spending2Wallet {
            let infoView = UIView()
            infoView.backgroundColor = .white
            infoView.layer.cornerRadius = 8
            infoView.layer.masksToBounds = true
            view.addSubview(infoView)
            infoView.snp.makeConstraints { make in
                make.top.equalTo(amountView.snp.bottom).offset(10)
                make.left.equalTo(16)
                make.right.equalTo(-16)
                make.height.equalTo(99)
            }

            let networkTitleLabel = UILabel(text: "Network", textColor: UIColor(hex: 0x333333), fontSize: 13, weight: .bold)
            infoView.addSubview(networkTitleLabel)
            networkTitleLabel.snp.makeConstraints { make in
                make.top.equalTo(12)
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
                make.top.equalTo(42)
                make.left.equalTo(10)
            }

            infoView.addSubview(feeLabel)
            feeLabel.snp.makeConstraints { make in
                make.centerY.equalTo(feeTitleLabel)
                make.right.equalTo(-10)
            }

            let maximumTitleLabel = UILabel(text: "Maximum withdraw", textColor: UIColor(hex: 0x333333), fontSize: 13, weight: .bold)
            infoView.addSubview(maximumTitleLabel)
            maximumTitleLabel.snp.makeConstraints { make in
                make.top.equalTo(69)
                make.left.equalTo(10)
            }

            infoView.addSubview(maximumLabel)
            maximumLabel.snp.makeConstraints { make in
                make.centerY.equalTo(maximumTitleLabel)
                make.right.equalTo(-10)
            }
        }


        let submitButton = UIButton.primary(title: "CONFIRM")
        submitButton.addTarget(self, action: #selector(submitButtonClick), for: .touchUpInside)
        view.addSubview(submitButton)
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(amountView.snp.bottom).offset(166)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }


    }



}

// MARK: - UITextFieldDelegate
extension WalletInternalTransferViewController: UITextFieldDelegate {

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