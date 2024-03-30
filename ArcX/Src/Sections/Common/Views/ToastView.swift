//
// Created by LLL on 2024/2/22.
//

import UIKit

class ToastView: UIView {

    private let container = UIView()
    private let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        container.backgroundColor = UIColor(hex: 0x000000, alpha: 1.0)
        container.layer.cornerRadius = 6
        container.layer.masksToBounds = true
        container.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onContainerTap(_:))))
        container.isUserInteractionEnabled = true
        addSubview(container)
        container.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.8)
        }

        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.numberOfLines = 0
        textLabel.isUserInteractionEnabled = false
        container.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12))
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func showToast(_ message: String, in view: UIView) {
        textLabel.text = message
        frame = view.bounds
        view.addSubview(self)
        alpha = 0
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 1.0
        }, completion: { b in

        })
        perform(#selector(hide), with: nil, afterDelay: 2.6)
    }

    @objc func hide() {
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseInOut, animations: {
            self.alpha = 0
        }, completion: { b in
            self.removeFromSuperview()
        })
    }

    @objc private func onContainerTap(_ recognizer: UIGestureRecognizer) {
        removeFromSuperview()
    }

    @discardableResult
    class func showToast(_ message: String, in view: UIView) -> ToastView {
        let toastView = ToastView()
        toastView.showToast(message, in: view)
        return toastView
    }

}

