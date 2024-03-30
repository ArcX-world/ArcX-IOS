//
// Created by LLL on 2024/3/27.
//

import UIKit
import SVGAPlayer

class MachineBonusViewController: BaseAlertController {

    var onCancel: (() -> Void)?
    var onPlay: (() -> Void)?

    var bonusItems: [BonusItem] = []

    init(bonusItems: [BonusItem]) {
        super.init(nibName: nil, bundle: nil)
        self.bonusItems = bonusItems
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let success = !bonusItems.isEmpty


        let contentView = UIView()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(view.frame.width)
        }

        let titleView = UIImageView()
        titleView.image = success ? UIImage(named: "img_mch_bonus_win") : UIImage(named: "img_mch_bonus_lose")
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        if success {

            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.spacing = 22
            contentView.addSubview(stackView)
            stackView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }

            for bonusItem in bonusItems {
                let contentView = UIView()

                let bonusView = UIImageView()
                bonusView.kf.setImage(with: URL(string: bonusItem.awdPct))
                bonusView.contentMode = .scaleAspectFit
                contentView.addSubview(bonusView)
                bonusView.snp.makeConstraints { make in
                    make.top.left.right.equalToSuperview()
                    if bonusItems.count == 1 {
                        make.size.equalTo(120)
                    } else if bonusItems.count == 2 {
                        make.size.equalTo(98)
                    } else {
                        make.size.equalTo(78)
                    }
                }

                let valueLabel = CustomLabel()
                valueLabel.fontSize = 21
                valueLabel.fonts = CustomLabel.Fonts.orange
                valueLabel.text = NSNumber(value: bonusItem.awdAmt).formatted(style: .decimal)
                contentView.addSubview(valueLabel)
                valueLabel.snp.makeConstraints { make in
                    if bonusItems.count == 1 {
                        make.top.equalTo(120 + 12)
                    } else if bonusItems.count == 2 {
                        make.top.equalTo(98 + 12)
                    } else {
                        make.top.equalTo(78 + 12)
                    }
                    make.centerX.equalToSuperview().offset(0)
                    make.bottom.equalToSuperview()
                }

                if bonusItem.cmdTp == BonusType.sol.rawValue {
                    valueLabel.snp.updateConstraints { make in
                        make.centerX.equalToSuperview().offset(30)
                    }

                    let iconView = UIImageView(image: UIImage(named: "img_bonus_sol_text"))
                    contentView.addSubview(iconView)
                    iconView.snp.makeConstraints { make in
                        make.centerY.equalTo(valueLabel)
                        make.right.equalTo(valueLabel.snp.left).offset(-6)
                        make.size.equalTo(CGSize(width: 59, height: 20))
                    }
                }

                stackView.addArrangedSubview(contentView)
            }

        } else {

            let rectView = UIView()
            rectView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.6)
            rectView.layer.cornerRadius = 12
            contentView.addSubview(rectView)
            rectView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
                make.size.equalTo(CGSize(width: 270, height: 98))
            }

            let textLabel = UILabel(text: nil, textColor: UIColor(hex: 0xFFFC7B))
            textLabel.text = "Gook luck next time！"
            textLabel.font = UIFont(name: "qiantuhouheiti", size: 30)
            textLabel.lineBreakMode = .byWordWrapping
            textLabel.numberOfLines = 0
            textLabel.textAlignment = .center
            rectView.addSubview(textLabel)
            textLabel.snp.makeConstraints { make in
                make.edges.equalTo(UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16))
            }

        }


        let cancelButton = UIButton.primary(title: "NO", titleColor: UIColor(hex: 0x333333), fontSize: 16)
        cancelButton.setBackgroundImage(UIImage(named: "img_mch_alert_btn"), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)

        let playButton = UIButton.primary(title: "ONCE AGAIN", titleColor: UIColor(hex: 0x333333), fontSize: 16)
        playButton.setBackgroundImage(UIImage(named: "img_mch_alert_btn"), for: .normal)
        playButton.addTarget(self, action: #selector(playButtonClick), for: .touchUpInside)

        let buttonStackView = UIStackView(arrangedSubviews: [ cancelButton, playButton ])
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        contentView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(340)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }


        let bgView = SVGAImageView()
        bgView.autoPlay = true
        bgView.imageName = "ani_db_bonus_bg"
        bgView.transform = CGAffineTransform.identity.translatedBy(x: Dimensions.WLR, y: Dimensions.WLR)
        contentView.insertSubview(bgView, at: 0)
        bgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(view.frame.size)
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if isBeingPresented {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
//                self.presentingViewController?.dismiss(animated: true)
//            }
//        }
    }

    override var isEnqueueForPresentation: Bool {
        return true
    }



    @objc private func cancelButtonClick() {
        onCancel?()
        presentingViewController?.dismiss(animated: true)
    }

    @objc private func playButtonClick() {
        onPlay?()
        presentingViewController?.dismiss(animated: true)
    }


}
