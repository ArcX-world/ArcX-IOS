//
// Created by LLL on 2024/3/19.
//

import UIKit

class SettingPlainViewCell: UIView {

    let iconView = UIImageView()
    let titleLabel = UILabel(text: nil, textColor: UIColor(hex: 0x333333), fontSize: 14, weight: .heavy)
    let subtitleLabel = UILabel(text: nil, textColor: UIColor(hex: 0x333333), fontSize: 13, weight: .heavy)

    var accessoryView: UIView? {
        didSet {
            oldValue?.removeFromSuperview()
            setNeedsLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: 0xF2F1FF)
        layer.cornerRadius = 12
        layer.masksToBounds = true

        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.equalTo(2)
            make.bottom.equalTo(-2)
            make.left.equalTo(6)
            make.size.equalTo(40)
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(46)
        }

        subtitleLabel.textAlignment = .right
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.minimumScaleFactor = 0.6
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
            make.width.equalTo(frame.width * 0.7)
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func updateConstraints() {
        titleLabel.snp.updateConstraints { make in
            make.left.equalTo(iconView.image == nil ? 14 : 46)
        }
        if let accessoryView = accessoryView {
            addSubview(accessoryView)
            accessoryView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalTo(-10)
            }
        }
        super.updateConstraints()
    }
}
