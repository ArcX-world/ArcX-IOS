//
// Created by LLL on 2024/3/18.
//

import UIKit

class UserAttributeViewCell: UICollectionViewCell {

    let typeView = UIImageView(image: UIImage(named: "img_profile_level"))

    let lvLabel = UILabel(text: nil)

    let progressView = UIImageView(image: UIImage(named: "img_profile_level_progress_value"))

    let progressLabel = UILabel(text: nil)

    let upView = UIImageView(image: UIImage(named: "img_profile_attr_up"))


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        let bgView = UIImageView(image: UIImage(named: "img_profile_attr_cell"))
        bgView.sizeToFit()
        bgView.frame.origin.y = 26
        contentView.addSubview(bgView)

        typeView.contentMode = .scaleAspectFit
        contentView.addSubview(typeView)
        typeView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 82))
        }

        contentView.addSubview(lvLabel)
        lvLabel.snp.makeConstraints { make in
            make.top.equalTo(bgView).offset(6)
            make.left.equalTo(bgView).offset(6)
        }

        let trackView = UIImageView(image: UIImage(named: "img_profile_attr_progress_track"))
        contentView.addSubview(trackView)
        trackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-8)
        }

        progressView.layer.mask = CAShapeLayer()
        progressView.layer.mask?.backgroundColor = UIColor.white.cgColor
        trackView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        progressLabel.adjustsFontSizeToFitWidth = true
        progressLabel.minimumScaleFactor = 0.6
        contentView.addSubview(progressLabel)
        progressLabel.snp.makeConstraints { make in
            make.centerX.equalTo(trackView)
            make.centerY.equalTo(trackView).offset(-2)
            make.width.lessThanOrEqualTo(80)
        }

        contentView.addSubview(upView)
        upView.snp.makeConstraints { make in
            make.centerY.equalTo(trackView)
            make.right.equalTo(trackView).offset(6)
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }


    // MARK: - Public

    func configCell(_ attr: UserAttribute) {
        lvLabel.attributedText = NSAttributedString(string: "LV\(attr.lv)", attributes: [
            .font: UIFont(name: "qiantuhouheiti", size: 14),
            .foregroundColor: UIColor.white,
            .strokeColor: UIColor(hex: 0x000000),
            .strokeWidth: -2,
            .shadow: NSShadow().then {
                $0.shadowColor = UIColor(hex: 0x000000, alpha: 0.5)
                $0.shadowOffset = CGSize(width: 0, height: 1)
            },
        ])

        progressLabel.attributedText = NSAttributedString(string: "\(attr.sdNma)/\(attr.sdDma)", attributes: [
            .font: UIFont(name: "qiantuhouheiti", size: 15),
            .foregroundColor: UIColor.white,
            .strokeColor: UIColor(hex: 0x000000),
            .strokeWidth: -2,
            .shadow: NSShadow().then {
                $0.shadowColor = UIColor(hex: 0x000000, alpha: 0.5)
                $0.shadowOffset = CGSize(width: 0, height: 1)
            },
        ])

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let progress = CGFloat(attr.sdNma) / CGFloat(attr.sdDma)
        progressView.layer.mask?.frame = CGRect(x: 0, y: 0, width: 124 * progress, height: 26)
        CATransaction.commit()


        upView.isHidden = !attr.upFlg

        switch attr.atbTp {
        case AttributeType.level.rawValue:
            typeView.image = UIImage(named: "img_profile_level")
            progressView.image = UIImage(named: "img_profile_level_progress_value")
        case AttributeType.energy.rawValue:
            typeView.image = UIImage(named: "img_profile_energy")
            progressView.image = UIImage(named: "img_profile_energy_progress_value")
        case AttributeType.charge.rawValue:
            typeView.image = UIImage(named: "img_profile_charge")
            progressView.image = UIImage(named: "img_profile_charge_progress_value")
        case AttributeType.income.rawValue:
            typeView.image = UIImage(named: "img_profile_income")
            progressView.image = UIImage(named: "img_profile_income_progress_value")
        case AttributeType.lucky.rawValue:
            typeView.image = UIImage(named: "img_profile_lucky")
            progressView.image = UIImage(named: "img_profile_lucky_progress_value")
        case AttributeType.charm.rawValue:
            typeView.image = UIImage(named: "img_profile_charm")
            progressView.image = UIImage(named: "img_profile_charm_progress_value")
        default:
            typeView.image = UIImage(named: "img_profile_level")
            progressView.image = UIImage(named: "img_profile_level_progress_value")
            break
        }
    }


}
