//
// Created by LLL on 2024/3/16.
//

import UIKit

class PusherComboView: UIView {

    private var value = NSDecimalNumber(value: 0)
    private var step: Int = 0

    private let label = CustomLabel()
    private var timer: Timer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = false
        alpha = 0
        transform = CGAffineTransform.identity.translatedBy(x: -100, y: 0)

        let textView = UIImageView(image: UIImage(named: "img_mch_combo"))
        addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }

        label.fontSize = 28
        label.fonts = CustomLabel.Fonts.blue
        addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(textView.snp.right).offset(4)
            make.right.equalToSuperview()
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func hit() {
        step += 1
        if let t = timer, t.isValid { return }
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [self] timer in
            if step > 0 {
                value = value.adding(.one)
                label.text = value.formatted(style: .decimal)
                step -= 1
                if step <= 0 {
                    NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fadeOut), object: nil)
                    self.perform(#selector(fadeOut), with: nil, afterDelay: 10)
                }
            }
        }
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.alpha = 1.0
            self.transform = CGAffineTransform.identity
        }
    }

    @objc private func fadeOut() {
        timer?.invalidate()
        value = NSDecimalNumber(value: 0)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 0
            self.transform = CGAffineTransform.identity.translatedBy(x: -100, y: 0)
        })
    }

}
