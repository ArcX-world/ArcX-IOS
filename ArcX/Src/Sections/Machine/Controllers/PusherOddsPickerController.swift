//
// Created by LLL on 2024/3/14.
//

import UIKit

class PusherOddsPickerController: BaseAlertController {

    var onSelect: ((MachineOddsItem) -> Void)?

    private var machine: MachineDetails!

    init(machine: MachineDetails) {
        super.init(nibName: nil, bundle: nil)
        self.machine = machine
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        isTapDismiss = true
        super.viewDidLoad()
        
        let contentView = UIImageView(image: UIImage(named: "img_mch_odds_alert"))
        contentView.isUserInteractionEnabled = true
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(38)
            make.centerX.equalToSuperview()
        }

        if let ptyMul = machine.ptyMul {
            for (i, item) in ptyMul.mulTbln.enumerated() {
                let btn = UIButton(type: .custom)
                btn.tag = i
                btn.contentHorizontalAlignment = .left
                btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 122, bottom: 0, right: 0)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
                btn.setTitleColor(UIColor(hex: 0x333333), for: .normal)
                btn.setTitle(NSNumber(value: item.mulAmt).formatted(style: .decimal), for: .normal)
                btn.setBackgroundImage(UIImage(named: "img_mch_odds_btn"), for: .normal)
                btn.addTarget(self, action: #selector(oddButtonClick(_:)), for: .touchUpInside)
                stackView.addArrangedSubview(btn)
            }
        }

    }

    @objc private func oddButtonClick(_ sender: UIButton) {
        if let ptyMul = machine.ptyMul {
            let item = ptyMul.mulTbln[sender.tag]
            presentingViewController?.dismiss(animated: true) {
                self.onSelect?(item)
                self.onSelect = nil
            }
        }
    }

}
