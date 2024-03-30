//
// Created by LLL on 2024/3/14.
//

import UIKit

class BottomNavigationBar: UIView {

    let titleLabel = UILabel(text: nil, textColor: .white, fontSize: 22)
    let backButton = UIButton(type: .custom)

    init(title: String?) {
        super.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 48))
        let bgView = UIImageView(image: UIImage(named: "img_nav_bg"))
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo(bgView.image!.size)
        }

        let backView = UIImageView(image: UIImage(named: "img_nav_back"))
        addSubview(backView)
        backView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
        }

        titleLabel.text = title
        titleLabel.font = UIFont(name: "qiantuhouheiti", size: 22)
        titleLabel.textColor = UIColor(hex: 0x66EEFF)
        titleLabel.shadowColor = UIColor(hex: 0x273C76)
        titleLabel.shadowOffset = CGSize(width: 0, height: 2)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-2)
        }

        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30))
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc private func backButtonClick() {
        currentViewController()?.navigationController?.popViewController(animated: true)
    }

}
