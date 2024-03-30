//
// Created by LLL on 2024/3/16.
//

import Foundation

class MachineToolbar: UIView {

    var items: [UIButton] = []

    private(set) var isSwitchOn: Bool = false
    private(set) var isVoiceOn: Bool = false


    lazy var switchButton = UIButton(type: .custom).then {
        $0.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        $0.setBackgroundImage(UIImage(named: "img_mch_switch_off_btn"), for: .normal)
        $0.addTarget(self, action: #selector(switchButtonClick), for: .touchUpInside)
    }

    lazy var repairButton = UIButton(type: .custom).then {
        $0.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        $0.setBackgroundImage(UIImage(named: "img_mch_fix_btn"), for: .normal)
    }

    lazy var voiceButton = UIButton(type: .custom).then {
        $0.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        $0.setBackgroundImage(UIImage(named: "img_mch_voice_on_btn"), for: .normal)
    }

    lazy var guideButton = UIButton(type: .custom).then {
        $0.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        $0.setBackgroundImage(UIImage(named: "img_mch_guide_btn"), for: .normal)
    }

    lazy var quitButton = UIButton(type: .custom).then {
        $0.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        $0.setBackgroundImage(UIImage(named: "img_mch_quit_btn"), for: .normal)
    }


    private weak var popupView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(switchButton)
        switchButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public

    func setSwitchOn(_ on: Bool) {
        isSwitchOn = on

        if on {
            popupView?.removeFromSuperview()
            switchButton.setBackgroundImage(UIImage(named: "img_mch_switch_on_btn"), for: .normal)

            let stackView = UIStackView()
            stackView.spacing = 4
            stackView.distribution = .equalSpacing
            stackView.axis = .vertical
            items.forEach({ stackView.addArrangedSubview($0) })
            stackView.frame.size = stackView.systemLayoutSizeFitting(CGSize(width: 0, height: 0))
            stackView.frame.origin = switchButton.convert(CGPoint(x: switchButton.frame.width - stackView.frame.width, y: switchButton.frame.height + stackView.spacing), to: superview)
            superview?.insertSubview(stackView, belowSubview: self)
            popupView = stackView
        } else {
            switchButton.setBackgroundImage(UIImage(named: "img_mch_switch_off_btn"), for: .normal)
            popupView?.removeFromSuperview()
        }
    }

    func setVoiceOn(_ on: Bool) {
        isVoiceOn = on
        if on {
            voiceButton.setBackgroundImage(UIImage(named: "img_mch_voice_on_btn"), for: .normal)
        } else {
            voiceButton.setBackgroundImage(UIImage(named: "img_mch_voice_off_btn"), for: .normal)
        }
    }

    @objc private func switchButtonClick() {
        setSwitchOn(!isSwitchOn)
    }

}