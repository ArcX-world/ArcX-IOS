//
// Created by LLL on 2024/3/20.
//

import Foundation

class CommonAlertController: BaseAlertController {

    let titleLabel = UILabel(text: "", textColor: UIColor(hex: 0x66EEFF))
    let contentView = UIImageView(image: UIImage(named: "img_mine_alert"))
    let buttonsStackView = UIStackView()
    var actionButtons: Array<UIButton> = []

    var actions: [AlertAction] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        contentView.isUserInteractionEnabled = true
        contentView.image = contentView.image?.resizableImage(withCapInsets: UIEdgeInsets(top: 200, left: 0, bottom: 44, right: 0), resizingMode: .stretch)
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(contentView.image!.size.width)
        }

        titleLabel.text = title
        titleLabel.font = UIFont(name: "qiantuhouheiti", size: 25)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(22)
        }

        let closeButton = UIButton(image: UIImage(named: "img_close"))
        closeButton.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin).offset(-50)
        }


        if actions.count > 0 {
            buttonsStackView.axis = .horizontal
            buttonsStackView.spacing = 16
            buttonsStackView.distribution = .fillEqually
            contentView.addSubview(buttonsStackView)
            buttonsStackView.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(-28)
            }

            for action in actions {
                let actionButton = UIButton.primary(title: action.title ?? "")
                actionButton.addTarget(self, action: #selector(actionButtonClick(_:)), for: .touchUpInside)
                buttonsStackView.addArrangedSubview(actionButton)
                actionButtons.append(actionButton)
            }
        }

    }

    func addAction(_ action: AlertAction) {
        actions.append(action)
    }

    // MARK: Private

    @objc private func closeButtonClick() {
        presentingViewController?.dismiss(animated: true)
    }

    @objc private func actionButtonClick(_ sender: UIButton) {
        let index = actionButtons.firstIndex(of: sender)!
        let action = actions[index]
        action.handler?(action)
    }

}
