//
// Created by LLL on 2024/3/19.
//

import UIKit

class DBTrainBonusViewController: BaseAlertController {

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

        let contentView = UIView()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(view.frame.width)
        }

        let titleView = UIImageView(image: UIImage(named: "img_dbt_title"))
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }

        let stackView = UIStackView(arrangedSubviews: bonusItems.map({ bonusItemView(with: $0) }))
        stackView.axis = .horizontal
        stackView.spacing = 16
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(34)
            make.centerX.equalToSuperview()
        }


        let btnShadow = NSShadow()
        btnShadow.shadowColor = UIColor(hex: 0xFFB7EF)
        btnShadow.shadowOffset = CGSize(width: 0, height: 2)

        let confirmButton = UIButton(type: .custom)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        confirmButton.contentEdgeInsets = UIEdgeInsets.zero
        confirmButton.titleEdgeInsets = UIEdgeInsets(top: -3, left: 0, bottom: 3, right: 0)
        confirmButton.setTitleColor(UIColor(hex: 0x333333), for: .normal)
        confirmButton.setAttributedTitle(NSAttributedString(string: "Collect", attributes: [ .shadow: btnShadow ]), for: .normal)
        confirmButton.setBackgroundImage(UIImage(named: "img_mch_alert_btn"), for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonClick), for: .touchUpInside)
        contentView.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(36)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }

//        let bgView = UIImageView(image: UIImage(named: "img_db_bonus_bg")?.resizeImage(withWidth: view.frame.width))
//        contentView.insertSubview(bgView, at: 0)
//        bgView.snp.makeConstraints { make in
//            make.centerX.equalTo(stackView)
//            make.centerY.equalTo(stackView).offset(-20)
//        }

    }


    // MARK: - Private

    private func bonusItemView(with bonusItem: BonusItem) -> UIView {
        let view = UIView()

        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: bonusItem.awdPct))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.size.equalTo(CGSize(width: 120, height: 94))
        }

        let textLabel = CustomLabel()
        textLabel.fontSize = 36
        textLabel.fonts = CustomLabel.Fonts.orange
        textLabel.text = NSNumber(value: bonusItem.awdAmt).formatted(style: .decimal)
        view.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        return view
    }

    @objc private func confirmButtonClick() {
        presentingViewController?.dismiss(animated: true)
    }

}
