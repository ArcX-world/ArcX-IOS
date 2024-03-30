//
// Created by LLL on 2024/3/14.
//

import UIKit

class TokenBalanceView: UIButton {

    var icon: UIImage? = UIImage(named: "img_game_token") {
        didSet { iconView.image = icon }
    }

    var value: NSNumber? {
        didSet { textLabel.text = value?.formatted(style: .decimal) }
    }

    let iconView = UIImageView(image: nil)
    let textLabel = UILabel(text: nil, textColor: .white, fontSize: 11, weight: .semibold)

    init(hasPlus: Bool) {
        super.init(frame: CGRect(x: 0, y: 0, width: 116, height: 30))
        let bgView = UIImageView()
        bgView.image = UIImage(named: "img_token_bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 20), resizingMode: .stretch)
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        iconView.image = icon
        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(4)
            make.size.equalTo(24)
        }

        let plusView = UIImageView(image: UIImage(named: "img_token_plus"))
        plusView.isHidden = !hasPlus
        addSubview(plusView)
        plusView.snp.makeConstraints { make in
            make.right.bottom.equalTo(iconView)
        }

        textLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.5
        textLabel.textAlignment = .center
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(34)
            make.right.equalTo(-16)
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
