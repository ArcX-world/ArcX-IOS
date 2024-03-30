//
// Created by LLL on 2024/3/13.
//

import UIKit

class MachineViewCell02: UICollectionViewCell {

    let nameLabel = UILabel(text: "Machine Name", textColor: .white, fontSize: 14, weight: .heavy)

    let machineView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        let bgView = UIImageView(frame: bounds)
        bgView.image = UIImage(named: "img_main_mch_cell2")
        contentView.addSubview(bgView)

        machineView.backgroundColor = UIColor(hex: 0xEEEEEE)
//        machineView.layer.borderWidth = 2.0
//        machineView.layer.borderColor = UIColor.white.cgColor
        machineView.layer.cornerRadius = 8
        machineView.layer.masksToBounds = true
        machineView.contentMode = .scaleAspectFill
        contentView.addSubview(machineView)
        machineView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: frame.width - 14, height: frame.height - 14))
        }

        nameLabel.font = UIFont(name: "qiantuhouheiti", size: 22)
        nameLabel.textColor = UIColor(hex: 0x66EEFF)
        nameLabel.shadowColor = UIColor(hex: 0x273C76)
        nameLabel.shadowOffset = CGSize(width: 0, height: 2)
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-16)
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configCell(_ machine: Machine) {
        nameLabel.text = machine.devNm
        machineView.kf.setImage(with: URL(string: machine.devPct))
    }
}
