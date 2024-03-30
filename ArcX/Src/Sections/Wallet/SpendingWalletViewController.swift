//
// Created by LLL on 2024/3/22.
//

import UIKit
import SwiftyJSON

class SpendingWalletViewController: BaseViewController {

    private var balanceMap: [WalletToken: Double] = [:]
    private var tokenViewMap: [WalletToken: WalletTokenView] = [:]


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = "Spending"
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
        walletProvider.request(.getSpendingWallet) { result in
            hud.hide()
            switch result {
            case .success(let response):
                do {
                    let json = try JSON(data: response.data)
                    for token in WalletToken.allValues {
                        let balance = json["serverMsg"][token.unit.lowercased()].doubleValue
                        self.balanceMap[token] = balance
                        self.tokenViewMap[token]?.valueLabel.text = NSNumber(value: balance).formatted(style: .decimal)
                    }
                } catch {}
                break
            case .failure(let error):
                ToastView.showToast(error.localizedDescription, in: self.view)
                break
            }
        }
    }

    @objc private func tokenViewTap(_ gesture: UIGestureRecognizer) {
        guard let tapView = gesture.view else { return }
        guard let token = tokenViewMap.first(where: { $0.value == tapView })?.key else { return }
        let transferViewController = WalletInternalTransferViewController(method: .spending2Wallet, token: token)
        transferViewController.balanceMap = balanceMap
        show(transferViewController, sender: nil)
    }


    private func commonInit() {
        view.backgroundColor = .clear

        let walletView = UIImageView()
        walletView.image = UIImage(named: "img_wallet_bg")
        walletView.isUserInteractionEnabled = true
        view.addSubview(walletView)
        walletView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(82)
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


}
