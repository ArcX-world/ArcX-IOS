//
// Created by LLL on 2024/3/29.
//

import UIKit

class MarketNFTViewCell: UICollectionViewCell {

    private let nameLabel = UILabel(text: nil, textColor: .white, fontSize: 14, weight: .heavy)
    private let nftView = UIImageView()
    private let priceLabel = UILabel(text: nil, textColor: UIColor(hex: 0x2A0B44), fontSize: 16, weight: .bold)
    private var attributeLabels: [UILabel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        let bgView = UIImageView(image: UIImage(named: "img_nft_mk_cell"))
        bgView.frame = bounds
        contentView.addSubview(bgView)

        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(12)
        }

        nftView.contentMode = .scaleAspectFill
        nftView.clipsToBounds = true
        contentView.addSubview(nftView)
        nftView.snp.makeConstraints { make in
            make.top.equalTo(36)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 98, height: 76))
        }

        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(185)
        }

        let attributeIcons = [
            UIImage(named: "img_nft_no"),
            UIImage(named: "img_nft_level"),
            UIImage(named: "img_nft_storage"),
            UIImage(named: "img_nft_discount"),
        ]

        for i in 0..<attributeIcons.count {
            let col = CGFloat(i % 2)
            let row = CGFloat(i / 2)

            let iconView = UIImageView(image: attributeIcons[i])
            iconView.frame = CGRect(x: 24 + 68 * col, y: 121 + 19 * row, width: 14, height: 14)
            contentView.addSubview(iconView)

            let textLabel = UILabel(text: nil, textColor: UIColor(hex: 0x4E4B4B), fontSize: 10, weight: .bold)
            textLabel.adjustsFontSizeToFitWidth = true
            textLabel.minimumScaleFactor = 0.5
            textLabel.frame = CGRect(x: iconView.frame.maxX + 4, y: iconView.frame.minY, width: 46, height: 14)
            contentView.addSubview(textLabel)

            attributeLabels.append(textLabel)
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configCell(_ nft: MarketNFT) {
        nameLabel.text = nft.nm
        nftView.kf.setImage(with: URL(string: nft.pct))

        var unit: String = ""
        if nft.slCmdTp == BonusType.usdt.rawValue {
            unit = "USDT"
        } else if nft.slCmdTp == BonusType.axcToken.rawValue {
            unit = "AXC"
        } else if nft.slCmdTp == BonusType.sol.rawValue {
            unit = "SOL"
        }
        priceLabel.text = NSNumber(value: nft.slAmt).formatted(style: .decimal) + unit



        attributeLabels.forEach({ $0.text = nil })
        var attributeValues: [String] = []
        attributeValues.append(nft.nftCd)
        if let attributes = nft.atbTbln {
            if let attr = attributes.first(where: { $0.atbTp == NFTAttributeType.level.rawValue }) {
                attributeValues.append("LV\(Int(attr.atbIfo))")
            }
            if let attr = attributes.first(where: { $0.atbTp == NFTAttributeType.storage.rawValue }) {
                attributeValues.append("LV\(Int(attr.atbIfo))")
            }
            if let attr = attributes.first(where: { $0.atbTp == NFTAttributeType.discount.rawValue }) {
                attributeValues.append(NSNumber(value: attr.atbIfo).formatted(style: .decimal) + "%")
            }
        }
        for i in 0..<attributeValues.count {
            if i < attributeLabels.count {
                attributeLabels[i].text = attributeValues[i]
            }
        }

    }

}
