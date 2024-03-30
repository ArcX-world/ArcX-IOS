//
// Created by LLL on 2024/3/28.
//

import UIKit

class NFTPropertyViewCell: UICollectionViewCell {

    var onOp: (() -> Void)?

    private let propertyView = UIImageView()
    private let propertyNameView = UIImageView()
    private let valueLabel = UILabel(text: nil, textColor: UIColor(hex: 0x333333), fontSize: 16, weight: .heavy)
    private let opButton = UIButton.primary(title: "OK", fontSize: 14)


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        let bgView = UIImageView(image: UIImage(named: "img_nft_property_cell"))
        bgView.frame = bounds
        contentView.addSubview(bgView)

        propertyView.contentMode = .scaleAspectFit
        contentView.addSubview(propertyView)
        propertyView.snp.makeConstraints { make in
            make.top.equalTo(21)
            make.centerX.equalToSuperview()
            make.size.equalTo(36)
        }

        contentView.addSubview(propertyNameView)
        propertyNameView.snp.makeConstraints { make in
            make.top.equalTo(75)
            make.centerX.equalToSuperview()
        }

        valueLabel.textAlignment = .center
        valueLabel.adjustsFontSizeToFitWidth = true
        valueLabel.minimumScaleFactor = 0.5
        contentView.addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(96)
            make.centerX.equalToSuperview()
            make.width.equalTo(frame.width - 12)
        }


        opButton.titleEdgeInsets = UIEdgeInsets(top: -2, left: 0, bottom: 2, right: 0)
        opButton.setBackgroundImage(UIImage(named: "img_nft_btn"), for: .normal)
        opButton.addTarget(self, action: #selector(opButtonClick), for: .touchUpInside)
        contentView.addSubview(opButton)
        opButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-8)
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: -

    func configCell(_ storage: BackpackNFTDetails.Storage) {
        propertyView.image = UIImage(named: "img_nft_axc")
        propertyNameView.image = UIImage(named: "img_nft_name_coin")
        valueLabel.text = NSNumber(value: storage.cnGdAmt).formatted(style: .decimal)

        let mutableString = NSMutableAttributedString(attributedString: opButton.attributedTitle(for: .normal)!)
        mutableString.replaceCharacters(in: NSMakeRange(0, mutableString.string.count), with: "ADD")
        opButton.setAttributedTitle(mutableString, for: .normal)
    }

    func configCell(_ durability: BackpackNFTDetails.Durability) {
        propertyView.image = UIImage(named: "img_nft_durability")
        propertyNameView.image = UIImage(named: "img_nft_name_durability")
        valueLabel.text = NSNumber(value: durability.durbtyAmt).formatted(style: .decimal)

        let mutableString = NSMutableAttributedString(attributedString: opButton.attributedTitle(for: .normal)!)
        mutableString.replaceCharacters(in: NSMakeRange(0, mutableString.string.count), with: "Repair")
        opButton.setAttributedTitle(mutableString, for: .normal)
    }

    func configCell(_ ad: Int) {
        propertyView.image = UIImage(named: "img_nft_ad")
        propertyNameView.image = UIImage(named: "img_nft_name_ad")
        valueLabel.text = NSNumber(value: ad).formatted(style: .decimal)

        let mutableString = NSMutableAttributedString(attributedString: opButton.attributedTitle(for: .normal)!)
        mutableString.replaceCharacters(in: NSMakeRange(0, mutableString.string.count), with: "AD")
        opButton.setAttributedTitle(mutableString, for: .normal)
    }


    // MARK: - Private

    @objc private func opButtonClick() {
        onOp?()
    }

}
