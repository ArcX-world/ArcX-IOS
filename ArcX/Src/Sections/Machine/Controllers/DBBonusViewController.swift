//
// Created by LLL on 2024/3/19.
//

import UIKit
import SVGAPlayer

class DBBonusViewController: BaseAlertController {

    var bonusItems: [BonusItem] = []
    var axcPosition: CGPoint = .zero
    var ballPosition: CGPoint = .zero

    private var axcView: UIView?
    private var ballView: UIView?

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

        let titleView = UIImageView(image: UIImage(named: "img_db_bonus_title"))
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 22
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(56)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-160)
        }

        for bonusItem in bonusItems {
            let contentView = UIView()

            var bonusView: UIView!

            if bonusItem.cmdTp == BonusType.axcToken.rawValue {
                let imageView = SVGAImageView()
                imageView.autoPlay = true
                imageView.imageName = "ani_axc_rotation"
                imageView.contentMode = .scaleAspectFit

                bonusView = UIView()
                bonusView.addSubview(imageView)
                imageView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            } else {
                let imageView = UIImageView()
                imageView.kf.setImage(with: URL(string: bonusItem.awdPct))
                imageView.contentMode = .scaleAspectFit
                bonusView = imageView
            }

            contentView.addSubview(bonusView)
            bonusView.snp.makeConstraints { make in
                make.top.left.right.equalToSuperview()
                if bonusItems.count == 1 {
                    make.size.equalTo(120)
                } else if bonusItems.count == 2 {
                    make.size.equalTo(98)
                } else {
                    make.size.equalTo(78)
                }
            }

            if bonusItem.cmdTp == BonusType.axcToken.rawValue {
                axcView = bonusView
            } else if bonusItem.cmdTp == BonusType.gameToken.rawValue {
                ballView = bonusView
            }

            let valueLabel = CustomLabel()
            valueLabel.fontSize = 21
            valueLabel.fonts = CustomLabel.Fonts.orange
            valueLabel.text = NSNumber(value: bonusItem.awdAmt).formatted(style: .decimal)
            contentView.addSubview(valueLabel)
            valueLabel.snp.makeConstraints { make in
                if bonusItems.count == 1 {
                    make.top.equalTo(120 + 12)
                } else if bonusItems.count == 2 {
                    make.top.equalTo(98 + 12)
                } else {
                    make.top.equalTo(78 + 12)
                }
                make.centerX.equalToSuperview().offset(0)
                make.bottom.equalToSuperview()
            }

            if bonusItem.cmdTp == BonusType.gameToken.rawValue {

                valueLabel.snp.updateConstraints { make in
                    make.centerX.equalToSuperview().offset(12)
                }

                let iconView = UIImageView(image: UIImage(named: "img_game_token"))
                contentView.addSubview(iconView)
                iconView.snp.makeConstraints { make in
                    make.centerY.equalTo(valueLabel)
                    make.right.equalTo(valueLabel.snp.left).offset(-2)
                    make.size.equalTo(24)
                }

            }

            stackView.addArrangedSubview(contentView)
        }


        let bgView = SVGAImageView()
        bgView.autoPlay = true
        bgView.imageName = "ani_db_bonus_bg"
        bgView.transform = CGAffineTransform.identity.translatedBy(x: Dimensions.WLR, y: Dimensions.WLR)
        contentView.insertSubview(bgView, at: 0)
        bgView.snp.makeConstraints { make in
            make.centerX.equalTo(stackView)
            make.centerY.equalTo(stackView).offset(-6)
            make.size.equalTo(view.frame.size)
        }

        AudioPlayer(fileName: "sound_db_bonus_show.mp3")?.play()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isBeingPresented {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                //self.presentingViewController?.dismiss(animated: true)
                self.fadeOut()
            }
        }
    }

    override var isEnqueueForPresentation: Bool {
        return true
    }

    private func fadeOut() {
//        if let axcView = axcView {
//            let frame = axcView.frame
//            let center = axcView.convert(CGPoint(x: axcView.frame.width * 0.5, y: axcView.frame.height * 0.5), to: view)
//            print("axc center: \(center)")
//            axcView.snp.removeConstraints()
//            DispatchQueue.main.async {
//                axcView.frame = frame
//                axcView.center = center
//                self.view.addSubview(axcView)
//            }
//        }
//
//        if let ballView = ballView {
//            let center = ballView.convert(CGPoint(x: ballView.frame.width * 0.5, y: ballView.frame.height * 0.5), to: view)
//            print("ball center: \(center)")
//            ballView.removeFromSuperview()
//            DispatchQueue.main.async {
//                ballView.center = center
//                self.view.addSubview(ballView)
//            }
//        }


        if let axcView = axcView {
            let frame = axcView.frame
            let center = axcView.convert(CGPoint(x: axcView.frame.width * 0.5, y: axcView.frame.height * 0.5), to: view)
            view.addSubview(axcView)
            axcView.snp.remakeConstraints { make in
                make.center.equalTo(center)
                make.size.equalTo(frame.size)
            }
        }

        if let ballView = ballView {
            let frame = ballView.frame
            let center = ballView.convert(CGPoint(x: ballView.frame.width * 0.5, y: ballView.frame.height * 0.5), to: view)
            view.addSubview(ballView)
            ballView.snp.remakeConstraints { make in
                make.center.equalTo(center)
                make.size.equalTo(frame.size)
            }
        }


        let flyPlayer = AudioPlayer(fileName: "sound_db_fly.mp3")
        flyPlayer?.prepareToPlay()

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.view.subviews.forEach({
                if $0 != self.axcView && $0 != self.ballView {
                    $0.alpha = 0.0
                }
            })
        }, completion: { b in

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                flyPlayer?.play()
            }

            UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {

                self.axcView?.center = self.axcPosition
                self.axcView?.transform = CGAffineTransform.identity.scaledBy(x: 0.2, y: 0.2)

                self.ballView?.center = self.ballPosition
                self.ballView?.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
            }, completion: { b in
                self.axcView?.removeFromSuperview()
                self.ballView?.removeFromSuperview()
                self.presentingViewController?.dismiss(animated: true)
            })

        })

    }

}

