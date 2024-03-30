//
// Created by LLL on 2024/3/25.
//

import UIKit

class TokenIntroViewController: BaseAlertController {

    var isGameToken: Bool = true
    init(isGameToken: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.isGameToken = isGameToken
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let contentView = UIImageView()
        contentView.image = UIImage(named: "img_main_intro_alert")?.resizableImage(withCapInsets: UIEdgeInsets(top: 74, left: 0, bottom: 74, right: 0), resizingMode: .stretch)
        contentView.isUserInteractionEnabled = true
        contentView.transform = CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2)
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(contentView.image!.size.width)
        }

        let tokenView = UIImageView()
        tokenView.image = UIImage(named: "img_game_token")
        contentView.addSubview(tokenView)
        tokenView.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.centerX.equalToSuperview()
            make.size.equalTo(36)
        }

        let nameLabel = UILabel(text: nil)
        if isGameToken {
            nameLabel.text = "Game coins"
        } else {
            nameLabel.text = "AXC coins"
        }
        nameLabel.textColor = UIColor(patternImage: UIImage.gradient(colors: [ UIColor(hex: 0xFFFE00), UIColor(hex: 0xFFBD00) ], size: CGSize(width: 12, height: 16), end: CGPoint(x: 0, y: 1)))
        nameLabel.font = UIFont(name: "qiantuhouheiti", size: 14)
        nameLabel.shadowColor = UIColor(hex: 0x7C4C11)
        nameLabel.shadowOffset = CGSize(width: 0, height: 2)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(tokenView.snp.bottom).offset(3)
            make.centerX.equalToSuperview()
        }


        let textLabel = UILabel(text: nil, textColor: .white, fontSize: 14, weight: .medium)
        if isGameToken {
            textLabel.text = "Game coins are always required to start arcade games. They can be purchased in the game store, and becoming a Web3 player can receive game coin airdrops for free every day."
        } else {
            textLabel.text = "AXC is an important token in the game. When you have energy, you can get it through the game and use it to upgrade your level and pay for goods."
        }
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.lessThanOrEqualTo(-30)
        }


        let closeButton = UIButton(image: UIImage(named: "img_close"))
        closeButton.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin).offset(-50)
        }

    }


    @objc private func closeButtonClick() {
        presentingViewController?.dismiss(animated: true)
    }


}
