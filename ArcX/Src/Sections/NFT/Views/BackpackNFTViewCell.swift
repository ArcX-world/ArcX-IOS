//
// Created by LLL on 2024/3/27.
//

import UIKit

class BackpackNFTViewCell: UICollectionViewCell {

    let bgView = UIImageView()
    let nftView = UIImageView()
    var attributeLabels: [UILabel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        bgView.frame = bounds
        contentView.addSubview(bgView)

        nftView.contentMode = .scaleAspectFit
        contentView.addSubview(nftView)
        nftView.snp.makeConstraints { make in
            make.top.equalTo(28)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 98, height: 76))
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
            iconView.frame = CGRect(x: 22 + 68 * col, y: 140 + 19 * row, width: 14, height: 14)
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

    // MARK: -

    func configCell(_ item: BackpackNFT) {
        attributeLabels.forEach({ $0.text = nil })

        if let status = BackpackNFT.Status(rawValue: item.stat) {
            switch status {
            case .idle:
                bgView.image = UIImage(named: "img_nft_bp_cell_idle")
            case .listing:
                bgView.image = UIImage(named: "img_nft_bp_cell_listing")
            case .advertising:
                bgView.image = UIImage(named: "img_nft_bp_cell_advertising")
            case .business:
                bgView.image = UIImage(named: "img_nft_bp_cell_operation")
            }
        }

        nftView.kf.setImage(with: URL(string: item.pct))

        var attributeValues: [String] = []
        attributeValues.append(item.nftCd)
        if let attributes = item.atbTbln {
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
