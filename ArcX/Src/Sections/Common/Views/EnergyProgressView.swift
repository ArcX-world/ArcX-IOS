//
// Created by LLL on 2024/3/14.
//

import UIKit
import SVGAPlayer

class EnergyProgressView: UIView, SVGAPlayerDelegate {

    private(set) var progress: CGFloat = 0
    private var value: Int = 0

    private let energyView = SVGAPlayer()
    private let valueView = UIImageView(image: UIImage(named: "img_energy_value"))
    private let textLabel = UILabel(text: "-", textColor: .white, fontSize: 10, weight: .semibold)
    private let diffLabel = UILabel(text: "", textColor: .white, fontSize: 10, weight: .semibold)

    override init(frame: CGRect) {
        super.init(frame: frame)
        let bgView = UIImageView()
        bgView.image = UIImage(named: "img_energy_bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 14), resizingMode: .stretch)
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        let trackView = UIImageView(image: UIImage(named: "img_energy_track"))
        trackView.image = trackView.image?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30), resizingMode: .stretch)
        addSubview(trackView)
        trackView.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerY.equalToSuperview().offset(-1)
            make.right.equalTo(-3)
        }

        valueView.image = valueView.image?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30), resizingMode: .stretch)
        valueView.layer.mask = CAShapeLayer()
        valueView.layer.mask?.frame = CGRect(x: 0, y: 0, width: 0, height: 16)
        valueView.layer.mask?.backgroundColor = UIColor.white.cgColor
        trackView.addSubview(valueView)
        valueView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        textLabel.font = UIFont(name: "qiantuhouheiti", size: 11)
        textLabel.shadowColor = UIColor(hex: 0x000000, alpha: 0.5)
        textLabel.shadowOffset = CGSize(width: 0, height: 1)
        trackView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-1)
        }


        energyView.loops = 1
        energyView.clearsAfterStop = false
        energyView.delegate = self
        addSubview(energyView)
        energyView.snp.makeConstraints { make in
            make.centerX.equalTo(trackView.snp.left).offset(1)
            make.centerY.equalTo(trackView)
            make.size.equalTo(24)
        }

        SVGAParser().parse(withNamed: "ani_energy_consume", in: nil) { videoItem in
            self.energyView.videoItem = videoItem
        }

        addSubview(diffLabel)
        diffLabel.snp.makeConstraints { make in
            make.centerY.equalTo(trackView)
            make.right.equalTo(-10)
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public

    func setProgress(_ value: Int, maximum: Int) {
        var animated: Bool = false

        let oldValue = self.value
        self.value = value
        if 0 < oldValue && value < oldValue {
            animated = true
        }

        progress = CGFloat(value) / CGFloat(maximum)
        let text = maximum == 0 ? "MAX" : "\(value)/\(maximum)"
        if animated {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [self] in
                energyView.startAnimation()
                textLabel.text = text
                valueView.layer.mask?.frame = CGRect(x: 0, y: 0, width: valueView.frame.width * progress, height: 16)

                diffLabel.text = "-\(oldValue - value)"
                diffLabel.alpha = 0
                UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
                    self.diffLabel.alpha = 1.0
                }, completion: { b in
                    UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseInOut, animations: {
                        self.diffLabel.alpha = 0.0
                    }, completion: { b in

                    })
                })
            }
        } else {
            textLabel.text = text

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            valueView.layer.mask?.frame = CGRect(x: 0, y: 0, width: valueView.frame.width * progress, height: 16)
            CATransaction.commit()
        }
    }


    // MARK: - SVGAPlayerDelegate

    func svgaPlayerDidFinishedAnimation(_ player: SVGAPlayer!) {
        player.step(toFrame: 0, andPlay: false)
    }


}
