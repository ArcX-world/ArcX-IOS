//
// Created by LLL on 2024/3/22.
//

import UIKit

class WalletTokenView: UIView {

    let valueLabel = UILabel(text: "0", textColor: .white, fontSize: 16, weight: .heavy)

    init(icon: UIImage?, name: String) {
        super.init(frame: CGRect())

        let iconBgView = UIImageView(image: UIImage.pure(color: UIColor(hex: 0x172038), size: CGSize(width: 36, height: 36), cornerRadius: 18))
        addSubview(iconBgView)
        iconBgView.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.left.equalTo(16)
            make.bottom.equalTo(-10)
            make.size.equalTo(36)
        }

        let iconView = UIImageView(image: icon)
        iconBgView.addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
        }

        let nameLabel = UILabel(text: name, textColor: .white, fontSize: 16, weight: .heavy)
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(iconBgView.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }

        addSubview(valueLabel)
        valueLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-16)
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
