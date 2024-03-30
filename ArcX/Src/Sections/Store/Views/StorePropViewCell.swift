//
// Created by LLL on 2024/3/20.
//

import UIKit

class StorePropViewCell: UICollectionViewCell {

    let bgView = UIImageView()
    let imageView = UIImageView()
    let countLabel = CustomLabel()
    let nameLabel = UILabel(text: nil)
    let priceView = UIView()
    let priceLabel = UILabel(text: nil)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        bgView.frame = bounds
        contentView.addSubview(bgView)

        imageView.frame = CGRect(x: 16, y: 35, width: 78, height: 58)
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)

        countLabel.fontSize = 18
        countLabel.fonts = CustomLabel.Fonts.gold
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.right.equalTo(imageView)
        }

        nameLabel.font = UIFont(name: "qiantuhouheiti", size: 22)
        nameLabel.textColor = UIColor(hex: 0xFFFFFF)
        nameLabel.shadowColor = UIColor(hex: 0x342472)
        nameLabel.shadowOffset = CGSize(width: 0, height: 2)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(95)
            make.centerX.equalToSuperview()
        }

        contentView.addSubview(priceView)
        priceView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-10)
        }

        let tokenView = UIImageView(image: UIImage(named: "img_axc_token")?.resizeImage(withWidth: 20))
        priceView.addSubview(tokenView)
        tokenView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }

        priceLabel.font = UIFont(name: "qiantuhouheiti", size: 22)
        priceLabel.textColor = UIColor(hex: 0xFBFC64)
        priceLabel.shadowColor = UIColor(hex: 0x000000, alpha: 0.5)
        priceLabel.shadowOffset = CGSize(width: 0, height: 2)
        priceView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.left.equalTo(tokenView.snp.right).offset(2)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview().offset(-2)
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public

    func configCell(_ product: StorePropProduct, col: Int) {
        bgView.image = UIImage(named: "img_store_product_cell_0\(col+2)")
        imageView.kf.setImage(with: URL(string: product.pct))
        nameLabel.text = product.nm
        countLabel.text = "X" + NSNumber(value: product.ppyAmt).formatted(style: .decimal)
        priceLabel.text = NSNumber(value: product.axcAmt).formatted(style: .decimal)
    }

}
