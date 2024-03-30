//
// Created by LLL on 2024/3/18.
//

import UIKit

class UserAttributesRadarView: UIView {

    var attributes: [CGFloat] = [ 1.0 , 0.0, 0.0, 0.0, 0.0, 0.0 ] {
        didSet { setNeedsDisplay() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 136, height: 148)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        UIImage(named: "img_profile_radar_bg")?.draw(in: rect)

        UIColor(hex: 0x8B90FF).setFill()

        let r: CGFloat = 50
        let center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)

        let path = UIBezierPath()
        for i in 0..<attributes.count {
            let angle: CGFloat = 360.0 / CGFloat(attributes.count) * CGFloat(i)
            let x1 = r * attributes[i] * cos((-90.0 + angle) * CGFloat.pi / 180) + center.x
            let y1 = r * attributes[i] * sin((-90.0 + angle) * CGFloat.pi / 180) + center.y
            if i == 0 {
                path.move(to: CGPoint(x: x1, y: y1))
            } else {
                path.addLine(to: CGPoint(x: x1, y: y1))
            }
        }
        path.close()
        path.fill()

        UIImage(named: "img_profile_radar_icon")?.draw(in: rect)
    }

}
