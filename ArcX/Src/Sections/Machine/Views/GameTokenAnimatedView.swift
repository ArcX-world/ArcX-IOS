//
// Created by LLL on 2024/3/16.
//

import UIKit

class GameTokenAnimatedView: UIView {

    init(number: NSNumber) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        isUserInteractionEnabled = false

        let iconView = UIImageView(image: UIImage(named: "img_game_token"))
        addSubview(iconView)
        iconView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
            make.size.equalTo(28)
        }

        let textLabel = CustomLabel()
        textLabel.fontSize = 27
        textLabel.text = number.formatted(style: .decimal)
        addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        frame.size = systemLayoutSizeFitting(CGSize(width: 0, height: 0))
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func startAnimation(in superview: UIView) {
        let x = CGFloat.random(in: 0..<(superview.frame.width - frame.width))
        let y = superview.frame.height
        frame.origin = CGPoint(x: x, y: y)
        superview.addSubview(self)

        UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -138)
        }, completion: { b in
            self.removeFromSuperview()
        })
        AudioPlayer(fileName: "sound_mch_get_coin.mp3")?.play()
    }

}
