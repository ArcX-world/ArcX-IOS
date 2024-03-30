//
// Created by MAC on 2023/11/2.
//

import UIKit

extension UIButton {

    convenience init(image: UIImage?) {
        self.init(type: .custom)
        setImage(image, for: .normal)
        contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
    }

    static func plain(title: String, titleColor: UIColor = UIColor(hex: 0x434343), fontSize: CGFloat = 14, weight: UIFont.Weight = .regular) -> UIButton {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setTitleColor(titleColor.withAlphaComponent(0.5), for: .highlighted)
        return button
    }


    static func primary(title: String, titleColor: UIColor = .white, fontSize: CGFloat = 20, weight: UIFont.Weight = .heavy) -> UIButton {
        let btn = UIButton(type: .custom)

        let titleOffset: CGFloat = fontSize > 16 ? 3 : 2
        btn.titleEdgeInsets = UIEdgeInsets(top: -titleOffset, left: 0, bottom: titleOffset, right: 0)

        let shadowOffset: CGFloat = fontSize > 17 ? 2 : 1
        let attributedTitle = NSAttributedString(string: title, attributes: [
            .foregroundColor: titleColor,
            .font: UIFont.systemFont(ofSize: fontSize, weight: weight),
            .shadow: NSShadow().then {
                $0.shadowColor = UIColor(hex: 0xF6BFEA)
                $0.shadowOffset = CGSize(width: 0, height: shadowOffset)
            }
        ])
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.setBackgroundImage(UIImage(named: "img_mine_alert_btn"), for: .normal)
        return btn
    }

}
