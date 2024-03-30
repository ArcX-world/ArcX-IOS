//
// Created by LLL on 2024/3/29.
//

import UIKit

class MarketNFTDetailsViewController: BaseViewController {


    var nft: MarketNFTDetails!
    init(nft: MarketNFTDetails) {
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


    // MARK: -

    @objc private func purchase() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        nftProvider.request(.purchaseNFT(identifier: nft.nftCd)) { result in
            hud.hide()
            switch result {
            case .success:
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: .MarketNFTDidChangeNotification, object: nil)
                NotificationCenter.default.post(name: .BackpackNFTDidChangeNotification, object: nil)
                break
            case .failure(let error):
                ToastView.showToast(error.localizedDescription, in: self.view)
                break
            }
        }
    }

    private func commonInit() {
        title = "NFT"
        view.backgroundColor = UIColor(hex: 0xDAD7EB)

        let topView = UIImageView()
        //topView.image = UIImage.gradient(colors: [ UIColor(hex: 0x6973E1), UIColor(hex: 0x886AF0) ], size: CGSize(width: view.frame.width, height: 292), end: CGPoint(x: 0, y: 1))
        topView.backgroundColor = .black
        view.insertSubview(topView, at: 0)
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(292)
        }

        let nftView = UIImageView()
        nftView.kf.setImage(with: URL(string: nft.pct))
        nftView.contentMode = .scaleAspectFit
        nftView.clipsToBounds = true
        topView.addSubview(nftView)
        nftView.snp.makeConstraints { make in
//            make.top.equalTo(topView.snp.topMargin).offset(60)
//            make.centerX.equalToSuperview()
//            make.bottom.equalTo(-16)
//            make.size.equalTo(CGSize(width: 232, height: 170))
            make.edges.equalToSuperview()
        }


        let scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }

        let scrollContentView = UIView()
        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.frame.width)
        }

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        scrollContentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.lessThanOrEqualToSuperview()
        }

        nft.atbTbln?.forEach { stackView.addArrangedSubview(buildAttributeViewCell(with: $0)) }


        var unit: String = ""
        if nft.slCmdTp == BonusType.usdt.rawValue {
            unit = "USDT"
        } else if nft.slCmdTp == BonusType.axcToken.rawValue {
            unit = "AXC"
        } else if nft.slCmdTp == BonusType.sol.rawValue {
            unit = "SOL"
        }
        let priceString = NSNumber(value: nft.slAmt).formatted(style: .decimal) + unit

        let buyButton = UIButton.plain(title: priceString, fontSize: 22, weight: .bold)
        buyButton.setBackgroundImage(UIImage(named: "img_nft_mk_btn"), for: .normal)
        buyButton.addTarget(self, action: #selector(purchase), for: .touchUpInside)
        scrollContentView.addSubview(buyButton)
        buyButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }


    }

    private func buildAttributeViewCell(with attribute: MarketNFTDetails.Attribute) -> UIView {
        let cell = UIImageView()
        cell.image = UIImage(named: "img_nft_attribute_cell")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 300, bottom: 0, right: 40), resizingMode: .stretch)

        let typeView = UIImageView()
        cell.addSubview(typeView)
        typeView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(32)
            make.size.equalTo(36)
        }

        let textLabel = UILabel(text: nil, textColor: UIColor(hex: 0x333333), fontSize: 16, weight: .semibold)
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        cell.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(94)
            make.centerY.equalToSuperview()
        }


        if let type = NFTAttributeType(rawValue: attribute.atbTp) {
            var text: String = ""
            switch type {
            case .level:
                typeView.image = UIImage(named: "img_nft_level")
                text = """
                       NFT Level: \(attribute.lv)
                       NFT EXP: \(attribute.atbMsg)
                       """
            case .storage:
                typeView.image = UIImage(named: "img_nft_storage")
                text = """
                       Space Level: \(attribute.lv)
                       Balance: \(attribute.atbMsg)
                       """
            case .discount:
                typeView.image = UIImage(named: "img_nft_discount")
                text = """
                       Discount Level: \(attribute.lv)
                       Discount Rate: \(attribute.atbMsg)
                       """
            }

            textLabel.attributedText = NSAttributedString(string: text, attributes: [
                .paragraphStyle: NSMutableParagraphStyle().then {
                    $0.lineSpacing = 4
                }
            ])
        }


        return cell
    }

}
