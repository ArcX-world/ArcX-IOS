//
// Created by LLL on 2024/3/16.
//

import UIKit

class MachineAlertController: BaseAlertController {


    let titleLabel = UILabel(text: nil, textColor: .white, fontSize: 20, weight: .heavy).then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.textAlignment = .center
    }

    let contentLabel = UILabel(text: nil, textColor: .white, fontSize: 18, weight: .medium).then {
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
        $0.textAlignment = .center
    }

    let contentView = UIImageView(image: nil)

    var actions: [AlertAction] = []

    var actionButtons: Array<UIButton> = []

    init(title: String?, content: String?) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = title
        contentLabel.text = content
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.image = UIImage(named: "img_mch_alert")?.resizableImage(withCapInsets: UIEdgeInsets(top: 145, left: 0, bottom: 42, right: 0), resizingMode: .stretch)
        contentView.isUserInteractionEnabled = true
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(contentView.image!.size.width)
            make.height.greaterThanOrEqualTo(contentView.image!.size.height)
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(32)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
        }

        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-80)
        }

        let actionsStackView = UIStackView(arrangedSubviews: [])
        actionsStackView.axis = .horizontal
        actionsStackView.spacing = 24
        actionsStackView.distribution = .fillEqually
        contentView.addSubview(actionsStackView)
        actionsStackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(contentLabel.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-32)
        }

        let btnShadow = NSShadow()
        btnShadow.shadowColor = UIColor(hex: 0xFFB7EF)
        btnShadow.shadowOffset = CGSize(width: 0, height: 2)

        for action in actions {
            let btn = UIButton(type: .custom)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            btn.contentEdgeInsets = UIEdgeInsets.zero
            btn.titleEdgeInsets = UIEdgeInsets(top: -3, left: 0, bottom: 3, right: 0)
            btn.setTitleColor(UIColor(hex: 0x333333), for: .normal)
            btn.setAttributedTitle(NSAttributedString(string: action.title ?? "", attributes: [ .shadow: btnShadow ]), for: .normal)
            btn.setBackgroundImage(UIImage(named: "img_mch_alert_btn"), for: .normal)
            btn.addTarget(self, action: #selector(actionButtonClick(_:)), for: .touchUpInside)
            actionButtons.append(btn)
            actionsStackView.addArrangedSubview(btn)
        }

    }

    func addAction(_ action: AlertAction) {
        actions.append(action)
    }


    // MARK: - Private

    @objc func actionButtonClick(_ sender: UIButton) {
        let index = actionButtons.firstIndex(of: sender)!
        presentingViewController?.dismiss(animated: true) {
            let action = self.actions[index]
            action.handler?(action)
            self.actions.removeAll()
        }
    }

    @objc private func closeButtonClick() {
        presentingViewController?.dismiss(animated: true)
    }
}


class AlertAction: NSObject {

    var title: String?
    var handler: ((AlertAction) -> Void)?

    init(title: String?, handler: ((AlertAction) -> Void)? = nil) {
        self.title = title
        self.handler = handler
    }
}