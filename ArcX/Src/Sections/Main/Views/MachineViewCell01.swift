//
// Created by LLL on 2024/3/13.
//

import UIKit

class MachineViewCell01: UICollectionViewCell {

    let nameLabel = UILabel(text: "Machine Name", textColor: .white, fontSize: 14, weight: .heavy)

    let machineView = UIImageView()

    let costLabel = UILabel(text: "200,000", textColor: .white, fontSize: 14, weight: .heavy)

    let avatarView = UIImageView()


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        let bgView = UIImageView(frame: bounds)
        bgView.image = UIImage(named: "img_main_mch_cell1")
        contentView.addSubview(bgView)

        nameLabel.font = UIFont(name: "qiantuhouheiti", size: 15)
        nameLabel.textColor = UIColor(hex: 0x66EEFF)
        nameLabel.shadowColor = UIColor(hex: 0x273C76)
        nameLabel.shadowOffset = CGSize(width: 0, height: 2)
        nameLabel.layer.shadowColor = UIColor(hex: 0x000000).cgColor
        nameLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        nameLabel.layer.shadowOpacity = 1.0
        nameLabel.layer.shadowRadius = 9.0
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.centerX.equalToSuperview()
        }

        machineView.backgroundColor = UIColor(hex: 0xEEEEEE)
//        machineView.layer.borderWidth = 2.0
//        machineView.layer.borderColor = UIColor.white.cgColor
        machineView.layer.cornerRadius = 8
        machineView.layer.masksToBounds = true
        machineView.contentMode = .scaleAspectFill
        contentView.addSubview(machineView)
        machineView.snp.makeConstraints { make in
            make.top.equalTo(32)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 160, height: 106))
        }

        avatarView.layer.cornerRadius = 10
        avatarView.layer.borderColor = UIColor.white.cgColor
        avatarView.layer.borderWidth = 1.0
        avatarView.layer.masksToBounds = true
        avatarView.contentMode = .scaleAspectFill
        avatarView.backgroundColor = UIColor(hex: 0xEEEEEE)
        contentView.addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.left.equalTo(machineView).offset(6)
            make.bottom.equalTo(machineView).offset(-6)
            make.size.equalTo(20)
        }

        costLabel.font = UIFont(name: "qiantuhouheiti", size: 16)
        costLabel.textColor = UIColor(hex: 0xFBFC64)
//        costLabel.shadowColor = UIColor(hex: 0x000000, alpha: 0.5)
//        costLabel.shadowOffset = CGSize(width: 0, height: 1)
        costLabel.layer.shadowColor = UIColor(hex: 0x3A1E4A).cgColor
        costLabel.layer.shadowOpacity = 0.8
        costLabel.layer.shadowOffset = CGSize(width: 0, height: 3)
        costLabel.layer.shadowRadius = 9
        contentView.addSubview(costLabel)
        costLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(10)
            make.top.equalTo(machineView.snp.bottom).offset(4)
        }

        let tokenView = UIImageView(image: UIImage(named: "img_game_token")?.resizeImage(withWidth: 16))
        contentView.addSubview(tokenView)
        tokenView.snp.makeConstraints { make in
            make.centerY.equalTo(costLabel).offset(2)
            make.right.equalTo(costLabel.snp.left).offset(-4)
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configCell(_ machine: Machine) {
        nameLabel.text = machine.devNm
        machineView.kf.setImage(with: URL(string: machine.devPct))
        costLabel.text = NSNumber(value: machine.csAmt).formatted(style: .decimal)
        costLabel.attributedText = NSAttributedString(string: NSNumber(value: machine.csAmt).formatted(style: .decimal), attributes: [
            .shadow: NSShadow().then {
                $0.shadowColor = UIColor(hex: 0x000000, alpha: 0.5)
                $0.shadowOffset = CGSize(width: 0, height: 1)
                $0.shadowBlurRadius = 2
            }
        ])

        if let player = machine.plyTbln?.first {
            avatarView.kf.setImage(with: URL(string: player.plyPct))
            avatarView.isHidden = false
        } else {
            avatarView.isHidden = true
        }

    }
}
