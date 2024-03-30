//
// Created by LLL on 2024/3/22.
//

import UIKit
import SwiftyJSON

class BlockchainWalletViewController: BaseViewController {

    private var walletAddress: String = ""
    private var balanceMap: [WalletToken: Double] = [:]
    private var tokenViewMap: [WalletToken: WalletTokenView] = [:]

    private let usdBalanceLabel = UILabel(text: "$0", textColor: UIColor(hex: 0x333333), fontSize: 26, weight: .bold)
    private let addressLabel = UILabel(text: nil, textColor: UIColor(hex: 0xACA7B7), fontSize: 12, weight: .semibold)
//    private let axcTokenView = WalletTokenView(icon: UIImage(named: "img_axc_token"), name: "AXC")
//    private let usdtTokenView = WalletTokenView(icon: UIImage(named: "img_usdt_token"), name: "USDT")
//    private let solTokenView = WalletTokenView(icon: UIImage(named: "img_sol_token"), name: "SOL")

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = "Wallet"
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: .WalletDidChangeNotification, object: nil)
        commonInit()
        loadData()

    }


    // MARK: - Private

    @objc private func loadData() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        walletProvider.request(.getBlockchainWallet) { result in
            hud.hide()
            switch result {
            case .success(let response):
                do {
                    let json = try JSON(data: response.data)

                    let address = json["serverMsg"]["wlAds"].stringValue
                    self.walletAddress = address
                    self.addressLabel.text = address

                    for token in WalletToken.allValues {
                        let balance = json["serverMsg"][token.unit.lowercased()].doubleValue
                        self.balanceMap[token] = balance
                        self.tokenViewMap[token]?.valueLabel.text = NSNumber(value: balance).formatted(style: .decimal)
                    }

                } catch { }
                break
            case .failure(let error):
                ToastView.showToast(error.localizedDescription, in: self.view)
                break
            }
        }
    }

    @objc private func receiveButtonClick() {
        if !walletAddress.isEmpty {
            present(WalletReceiveViewController(address: walletAddress), animated: true)
        }
    }

    @objc private func spendingButtonClick() {
        let transferViewController = WalletInternalTransferViewController(method: .wallet2Spending, token: .axc)
        transferViewController.balanceMap = balanceMap
        show(transferViewController, sender: nil)
    }

    @objc private func externalButtonClick() {
        let transferViewController = ExternalTransferViewController()
        transferViewController.balanceMap = balanceMap
        show(transferViewController, sender: nil)
    }

    @objc private func tradeButtonClick() {

    }

    @objc private func tokenViewTap(_ gesture: UIGestureRecognizer) {
        guard let tapView = gesture.view else { return }
        guard let token = tokenViewMap.first(where: { $0.value == tapView })?.key else { return }
        let transferViewController = WalletInternalTransferViewController(method: .wallet2Spending, token: token)
        transferViewController.balanceMap = balanceMap
        show(transferViewController, sender: nil)
    }


    private func commonInit() {
        view.backgroundColor = .clear

        let topView = UIView()
        topView.backgroundColor = UIColor(hex: 0xCBB6FC)
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        topView.addSubview(usdBalanceLabel)
        usdBalanceLabel.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.topMargin).offset(76)
            make.centerX.equalToSuperview()
        }


        let addressView = UIImageView()
        addressView.image = UIImage(named: "img_wallet_address")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50), resizingMode: .stretch)
        topView.addSubview(addressView)
        addressView.snp.makeConstraints { make in
            make.top.equalTo(usdBalanceLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 212, height: 26))
        }

        addressLabel.textAlignment = .center
        addressLabel.lineBreakMode = .byTruncatingMiddle
        addressView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }


        let transferView = UIImageView(image: UIImage(named: "img_wallet_spending_external"))
        topView.addSubview(transferView)
        transferView.snp.makeConstraints { make in
            make.top.equalTo(addressView.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-26)
            make.size.equalTo(transferView.image!.size)
        }


        let spendingButton = buildIconButton(with: UIImage(named: "img_wallet_spending")!, title: "To Spending", spacing: 4)
        spendingButton.addTarget(self, action: #selector(spendingButtonClick), for: .touchUpInside)
        topView.addSubview(spendingButton)
        spendingButton.snp.makeConstraints { make in
            make.top.equalTo(transferView).offset(-5)
            make.centerX.equalTo(transferView.snp.left).offset(30)
        }

        let externalButton = buildIconButton(with: UIImage(named: "img_wallet_external")!, title: "To external", spacing: 4)
        externalButton.addTarget(self, action: #selector(externalButtonClick), for: .touchUpInside)
        topView.addSubview(externalButton)
        externalButton.snp.makeConstraints { make in
            make.top.equalTo(spendingButton)
            make.centerX.equalTo(transferView.snp.right).offset(-30)
        }

        let receiveButton = buildIconButton(with: UIImage(named: "img_wallet_receive")!, title: "Receive", spacing: 4)
        receiveButton.addTarget(self, action: #selector(receiveButtonClick), for: .touchUpInside)
        topView.addSubview(receiveButton)
        receiveButton.snp.makeConstraints { make in
            make.top.equalTo(spendingButton)
            make.right.equalTo(transferView.snp.left).offset(-16)
        }

        let tradeButton = buildIconButton(with: UIImage(named: "img_wallet_trade")!, title: "Trade", spacing: 4)
        tradeButton.addTarget(self, action: #selector(tradeButtonClick), for: .touchUpInside)
        topView.addSubview(tradeButton)
        tradeButton.snp.makeConstraints { make in
            make.top.equalTo(spendingButton)
            make.left.equalTo(transferView.snp.right).offset(16)
        }


        let walletView = UIImageView()
        walletView.image = UIImage(named: "img_wallet_bg")
        walletView.isUserInteractionEnabled = true
        view.addSubview(walletView)
        walletView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }

        let iconView = UIImageView(image: UIImage(named: "img_wallet_arcx"))
        walletView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.left.equalTo(11)
            make.size.equalTo(26)
        }

        let titleLabel = UILabel(text: title, textColor: .white, fontSize: 16, weight: .heavy)
        walletView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(42)
            make.centerY.equalTo(iconView)
        }

        let tokens: [WalletToken] = [ .sol, .axc, .usdt ]
        for (i, token) in tokens.enumerated() {
            let tokenView = WalletTokenView(icon: UIImage(named: "img_\(token.unit.lowercased())_token"), name: token.unit)
            tokenView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tokenViewTap(_:))))
            walletView.addSubview(tokenView)
            tokenView.snp.makeConstraints { make in
                make.top.equalTo(44 + 56 * CGFloat(i))
                make.left.right.equalToSuperview()
            }

            tokenViewMap[token] = tokenView

            if i != tokens.count - 1 {
                let line = UIView()
                line.backgroundColor = UIColor(hex: 0x7D64D5, alpha: 1.0)
                walletView.insertSubview(line, belowSubview: tokenView)
                line.snp.makeConstraints { make in
                    make.left.equalTo(14)
                    make.right.equalTo(-14)
                    make.bottom.equalTo(tokenView)
                    make.height.equalTo(1)
                }
            }
        }

    }

    private func buildIconButton(with icon: UIImage, title: String, spacing: CGFloat) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        btn.setImage(icon, for: .normal)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor(hex: 0x444444), for: .normal)

        let imageSize = icon.size
        let titleSize = (title as NSString).size(withAttributes: [ .font: btn.titleLabel!.font ])
        let titleOffset = imageSize.height + spacing
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -titleOffset, right: 0)
        let imageOffset = titleSize.height + spacing
        btn.imageEdgeInsets = UIEdgeInsets(top: -imageOffset, left: 0, bottom: 0, right: -titleSize.width)
        let edgeOffset = abs(titleSize.height - imageSize.height) / 2.0
        btn.contentEdgeInsets = UIEdgeInsets(top: edgeOffset, left: 0.0, bottom: edgeOffset, right: 0.0)

        return btn
    }



}
