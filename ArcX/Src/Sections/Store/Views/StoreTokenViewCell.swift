//
// Created by LLL on 2024/3/20.
//

import UIKit

class StoreTokenViewCell: UICollectionViewCell {

    let bgView = UIImageView()
    let imageView = UIImageView()
    let countLabel = CustomLabel()
    let priceLabel = UILabel(text: nil)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        bgView.frame = bounds
        bgView.image = UIImage(named: "img_store_product_cell_01")
        contentView.addSubview(bgView)

        imageView.frame = CGRect(x: 8, y: 22, width: 100, height: 70)
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)

        countLabel.fontSize = 16
        countLabel.fonts = CustomLabel.Fonts.gold
        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(98)
            make.centerX.equalToSuperview()
        }

        priceLabel.font = UIFont(name: "qiantuhouheiti", size: 22)
        priceLabel.textColor = UIColor(hex: 0xFBFC64)
        priceLabel.shadowColor = UIColor(hex: 0x000000, alpha: 0.5)
        priceLabel.shadowOffset = CGSize(width: 0, height: 2)
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(12)
            make.bottom.equalTo(-9)
        }

        let tokenView = UIImageView(image: UIImage(named: "img_usdt_token"))
        contentView.addSubview(tokenView)
        tokenView.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel).offset(2)
            make.right.equalTo(priceLabel.snp.left).offset(-3)
            make.size.equalTo(20)
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public

    func configCell(_ product: StoreTokenProduct) {
        imageView.kf.setImage(with: URL(string: product.pct))
        countLabel.text = NSNumber(value: product.cnAmt).formatted(style: .decimal)
        priceLabel.text = NSNumber(value: product.usdtAmt).formatted(style: .decimal)
    }

}
