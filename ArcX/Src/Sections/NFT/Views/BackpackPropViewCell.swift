//
// Created by LLL on 2024/3/30.
//

import UIKit

class BackpackPropViewCell: UICollectionViewCell {

    private let propView = UIImageView()
    private let countLabel = UILabel(text: nil, textColor: .white, fontSize: 10, weight: .semibold)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        let bgView = UIImageView(image: UIImage(named: "img_nft_prop_cell"))
        bgView.frame = bounds
        contentView.addSubview(bgView)

        propView.contentMode = .scaleAspectFit
        contentView.addSubview(propView)
        propView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-2)
            make.size.equalTo(42)
        }

        contentView.addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.right.equalTo(-6)
            make.bottom.equalTo(-6)
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }


    func configCell(_ prop: BackpackProp) {
        propView.kf.setImage(with: URL(string: prop.pct))
        countLabel.text = "x" + NSNumber(value: prop.ppyAmt).formatted(style: .decimal)
    }
}
