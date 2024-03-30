//
// Created by MAC on 2023/11/2.
//

import UIKit

extension UILabel {

    convenience init(text: String? = nil, textColor: UIColor = UIColor(hex: 0x333333), fontSize: CGFloat = 14, weight: UIFont.Weight = .regular) {
        self.init()
        self.text = text
        self.textColor = textColor
        font = UIFont.systemFont(ofSize: fontSize, weight: weight)
    }

}