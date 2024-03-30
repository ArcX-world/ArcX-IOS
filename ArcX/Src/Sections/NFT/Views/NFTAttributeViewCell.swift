//
// Created by LLL on 2024/3/27.
//

import UIKit

class NFTAttributeViewCell: UICollectionViewCell {

    var onUpgrade: (() -> Void)?

    let typeView = UIImageView()
    let typeNameView = UIImageView()
    let levelLabel = UILabel(text: "LV", textColor: UIColor(hex: 0x333333), fontSize: 12, weight: .heavy)
    let progressValueView = UIImageView()
    let attributeValueLabel = UILabel(text: nil, textColor: UIColor(hex: 0x333333), fontSize: 12, weight: .heavy)
    let nextAttributeValueLabel = UILabel(text: nil, textColor: UIColor(hex: 0x4ACB4B), fontSize: 12, weight: .heavy)
    let upgradeButton = UIButton.primary(title: "Upgrade", fontSize: 14)
    let upgradeView = UIImageView(image: UIImage(named: "img_nft_upgrade"))


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        let bgView = UIImageView()
        bgView.image = UIImage(named: "img_nft_attribute_cell")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 300, bottom: 0, right: 40), resizingMode: .stretch)
        bgView.frame = bounds
        contentView.addSubview(bgView)

        typeView.contentMode = .scaleAspectFit
        contentView.addSubview(typeView)
        typeView.snp.makeConstraints { make in
            make.left.equalTo(33)
            make.centerY.equalToSuperview()
            make.size.equalTo(34)
        }

        contentView.addSubview(typeNameView)
        typeNameView.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.left.equalTo(90)
        }

        contentView.addSubview(levelLabel)
        levelLabel.snp.makeConstraints { make in
            make.centerY.equalTo(typeNameView)
            make.left.equalTo(typeNameView.snp.right).offset(6)
        }

        let progressTrackView = UIImageView(image: UIImage.pure(color: UIColor(hex: 0x000000, alpha: 0.5), size: CGSize(width: 82, height: 8), cornerRadius: 4))
        contentView.addSubview(progressTrackView)
        progressTrackView.snp.makeConstraints { make in
            make.top.equalTo(42)
            make.left.equalTo(90)
        }

        progressValueView.layer.mask = CAShapeLayer()
        progressValueView.layer.mask?.frame = CGRect(x: 0, y: 0, width: 82, height: 8)
        progressValueView.layer.mask?.backgroundColor = UIColor.white.cgColor
        progressTrackView.addSubview(progressValueView)
        progressValueView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        upgradeButton.titleEdgeInsets = UIEdgeInsets(top: -2, left: 0, bottom: 2, right: 0)
        upgradeButton.setBackgroundImage(UIImage(named: "img_nft_btn"), for: .normal)
        upgradeButton.addTarget(self, action: #selector(upgradeButtonClick), for: .touchUpInside)
        contentView.addSubview(upgradeButton)
        upgradeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
        }

        upgradeButton.addSubview(upgradeView)
        upgradeView.snp.makeConstraints { make in
            make.bottom.right.equalToSuperview()
        }

        contentView.addSubview(attributeValueLabel)
        attributeValueLabel.snp.makeConstraints { make in
            make.top.equalTo(progressTrackView.snp.bottom).offset(6)
            make.left.equalTo(progressTrackView)
        }

        let transferView = UIImageView(image: UIImage(named: "img_profile_attr_transfer"))
        contentView.addSubview(transferView)
        transferView.snp.makeConstraints { make in
            make.centerY.equalTo(attributeValueLabel)
            make.left.equalTo(attributeValueLabel.snp.right).offset(4)
        }

        contentView.addSubview(nextAttributeValueLabel)
        nextAttributeValueLabel.snp.makeConstraints { make in
            make.centerY.equalTo(attributeValueLabel)
            make.left.equalTo(transferView.snp.right).offset(4)
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configCell(_ attribute: BackpackNFTDetails.Attribute) {
        if let type = NFTAttributeType(rawValue: attribute.atbTp) {
            switch type {
            case .level:
                typeView.image = UIImage(named: "img_nft_level")
                typeNameView.image = UIImage(named: "img_nft_name_level")
                progressValueView.image = UIImage.gradient(colors: [ UIColor(hex: 0xFFFE00), UIColor(hex: 0xFFBD00) ], size: CGSize(width: 82, height: 8), end: CGPoint(x: 1, y: 0), cornerRadius: 4)
                attributeValueLabel.text = "LV\(Int(attribute.lvAmt))"
                nextAttributeValueLabel.text = "LV\(Int(attribute.nxLvAmt))"
            case .storage:
                typeView.image = UIImage(named: "img_nft_storage")
                typeNameView.image = UIImage(named: "img_nft_name_space")
                progressValueView.image = UIImage.gradient(colors: [ UIColor(hex: 0x4096FB), UIColor(hex: 0x66EFFF) ], size: CGSize(width: 82, height: 8), end: CGPoint(x: 1, y: 0), cornerRadius: 4)
                attributeValueLabel.text = NSNumber(value: attribute.lvAmt).formatted(style: .decimal)
                nextAttributeValueLabel.text = NSNumber(value: attribute.nxLvAmt).formatted(style: .decimal)
            case .discount:
                typeView.image = UIImage(named: "img_nft_discount")
                typeNameView.image = UIImage(named: "img_nft_name_discount")
                progressValueView.image = UIImage.gradient(colors: [ UIColor(hex: 0xFFC0F4), UIColor(hex: 0xE49BFF) ], size: CGSize(width: 82, height: 8), end: CGPoint(x: 1, y: 0), cornerRadius: 4)
                attributeValueLabel.text = NSNumber(value: attribute.lvAmt).formatted(style: .decimal) + "%"
                nextAttributeValueLabel.text = NSNumber(value: attribute.nxLvAmt).formatted(style: .decimal) + "%"
            }
        }

        levelLabel.text = "LV\(attribute.lv)"
        upgradeView.isHidden = !attribute.upFlg

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let progress = CGFloat(attribute.sdDma) / CGFloat(attribute.sdNma)
        progressValueView.layer.mask?.frame = CGRect(x: 0, y: 0, width: 82 * progress, height: 8)
        CATransaction.commit()

    }


    @objc private func upgradeButtonClick() {
        onUpgrade?()
    }


}
