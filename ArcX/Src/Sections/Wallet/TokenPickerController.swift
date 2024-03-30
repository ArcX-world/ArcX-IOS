//
// Created by LLL on 2024/3/25.
//

import UIKit

class TokenPickerController: BaseViewController {

    var onSelect: ((WalletToken) -> Void)?

    private var tokens: [WalletToken] = WalletToken.allValues

    private var buttons: [UIButton] = []

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }


    @objc private func dismissVC() {
        presentingViewController?.dismiss(animated: true)
    }

    @objc private func tokenButtonClick(_ sender: UIButton) {
        guard let index = buttons.index(of: sender) else { return }
        onSelect?(tokens[index])
        presentingViewController?.dismiss(animated: true)
    }

    private func commonInit() {

        let dismissView = UIView(frame: view.bounds)
        dismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissVC)))
        view.addSubview(dismissView)

        let contentView = UIImageView()
        contentView.isUserInteractionEnabled = true
        contentView.image = UIImage.gradient(colors: [ UIColor(hex: 0xCDD1FB), UIColor(hex: 0xE0D7FF) ],
                locations: nil,
                size: CGSize(width: view.frame.width, height: 446),
                start: CGPoint(),
                end: CGPoint(x: 0, y: 1),
                cornerRadius: 16,
                corners: [ .topLeft, .topRight ])
        contentView.layer.shadowColor = UIColor(hex: 0x000000).cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 0)
        contentView.layer.shadowRadius = 10
        contentView.layer.shadowOpacity = 0.4
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.size.equalTo(contentView.image!.size)
        }


        for token in tokens {
            let btn = UIButton(type: .custom)
            btn.setImage(UIImage.pure(color: UIColor(hex: 0x172038), size: CGSize(width: 36, height: 36), cornerRadius: 16), for: .normal)
            btn.setTitle(token.unit, for: .normal)
            btn.setBackgroundImage(UIImage.pure(color: UIColor(hex: 0xFFFFFF), size: CGSize(width: 300, height: 56), cornerRadius: 16), for: .normal)
            btn.setTitleColor(UIColor(hex: 0x333333), for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            btn.contentHorizontalAlignment = .left
            btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
            btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
            btn.addTarget(self, action: #selector(tokenButtonClick(_:)), for: .touchUpInside)

            let tokenView = UIImageView(image: UIImage(named: "img_\(token.unit.lowercased())_token"))
            btn.addSubview(tokenView)
            tokenView.snp.makeConstraints { make in
                make.center.equalTo(btn.imageView!)
                make.size.equalTo(32)
            }

            buttons.append(btn)
        }

        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(26)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }

    }

}
