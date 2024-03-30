//
// Created by LLL on 2024/3/29.
//

import UIKit

class NFTEarnViewCell: UICollectionViewCell {

    private let dateLabel = UILabel(text: "", textColor: UIColor(hex: 0xFFFFFF), fontSize: 16, weight: .heavy)
    private let durationLabel = UILabel(text: "", textColor: UIColor(hex: 0x333333), fontSize: 13, weight: .bold)
    private let priceLabel = UILabel(text: "", textColor: UIColor(hex: 0xE09927), fontSize: 13, weight: .bold)
    private let incomeLabel = UILabel(text: "", textColor: UIColor(hex: 0x0EBF63), fontSize: 13, weight: .bold)
    private let balanceLabel = UILabel(text: "", textColor: UIColor(hex: 0xE09927), fontSize: 13, weight: .bold)
    private let taxLabel = UILabel(text: "", textColor: UIColor(hex: 0xFF6D3B), fontSize: 13, weight: .bold)



    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        let bgView = UIImageView(frame: bounds)
        bgView.image = UIImage(named: "img_nft_report_cell")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 100), resizingMode: .stretch)
        contentView.addSubview(bgView)

        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(15)
        }

        let timeTitleLabel = UILabel(text: "Time", textColor: UIColor(hex: 0x333333), fontSize: 13, weight: .bold)
        contentView.addSubview(timeTitleLabel)
        timeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(38)
            make.left.equalTo(12)
        }

        let priceTitleLabel = UILabel(text: "Price", textColor: UIColor(hex: 0x333333), fontSize: 13, weight: .bold)
        contentView.addSubview(priceTitleLabel)
        priceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(timeTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(12)
        }

        let incomeTitleLabel = UILabel(text: "Income", textColor: UIColor(hex: 0x333333), fontSize: 13, weight: .bold)
        contentView.addSubview(incomeTitleLabel)
        incomeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(priceTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(12)
        }

        let balanceTitleLabel = UILabel(text: "Balance", textColor: UIColor(hex: 0x333333), fontSize: 13, weight: .bold)
        contentView.addSubview(balanceTitleLabel)
        balanceTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(incomeTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(12)
        }

        let taxTitleLabel = UILabel(text: "Tax", textColor: UIColor(hex: 0x333333), fontSize: 13, weight: .bold)
        contentView.addSubview(taxTitleLabel)
        taxTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(balanceTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(12)
        }


        contentView.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.centerY.equalTo(timeTitleLabel)
            make.right.equalTo(-10)
        }

        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceTitleLabel)
            make.right.equalTo(-10)
        }

        contentView.addSubview(incomeLabel)
        incomeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(incomeTitleLabel)
            make.right.equalTo(-10)
        }

        contentView.addSubview(balanceLabel)
        balanceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(balanceTitleLabel)
            make.right.equalTo(-10)
        }

        contentView.addSubview(taxLabel)
        taxLabel.snp.makeConstraints { make in
            make.centerY.equalTo(taxTitleLabel)
            make.right.equalTo(-10)
        }

        let usdtView = UIImageView(image: UIImage(named: "img_usdt_token"))
        contentView.addSubview(usdtView)
        usdtView.snp.makeConstraints { make in
            make.centerY.equalTo(incomeLabel)
            make.right.equalTo(incomeLabel.snp.left).offset(-4)
            make.size.equalTo(16)
        }

        let coinView = UIImageView(image: UIImage(named: "img_game_token"))
        contentView.addSubview(coinView)
        coinView.snp.makeConstraints { make in
            make.centerY.equalTo(balanceLabel)
            make.right.equalTo(balanceLabel.snp.left).offset(-4)
            make.size.equalTo(16)
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }


    func configCell(_ item: NFTEarnItem) {
        dateLabel.text = Date(timeIntervalSince1970: item.opTm / 1000).formatted(.date)

        let hour = item.opTlTm / 3600
        let minute = item.opTlTm % 3600 / 60
        let second = item.opTlTm % 60
        durationLabel.text = String(format: "%02d:%02d:%02d", hour, minute, second)

        let price = NSNumber(value: item.opPrc).formatted(style: .decimal)
        priceLabel.text = "1USDT=\(price) coins"

        incomeLabel.text = NSNumber(value: item.inc).formatted(style: .decimal)
        balanceLabel.text = NSNumber(value: item.blAmt).formatted(style: .decimal)
        taxLabel.text = NSNumber(value: item.tax).formatted(style: .decimal) + "%"
    }


}
