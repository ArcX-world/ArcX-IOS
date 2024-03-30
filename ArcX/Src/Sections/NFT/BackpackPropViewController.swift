//
// Created by LLL on 2024/3/30.
//

import UIKit

class BackpackPropViewController: CommonAlertController {

    var prop: BackpackProp!
    init(prop: BackpackProp) {
        super.init(nibName: nil, bundle: nil)
        self.prop = prop
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        title = "Use"
        addAction(AlertAction(title: "USE") { [weak self] _ in
            self?.useBackpackProp()
        })
        super.viewDidLoad()

        let propView = UIImageView()
        propView.kf.setImage(with: URL(string: prop.pct))
        propView.contentMode = .scaleAspectFit
        contentView.addSubview(propView)
        propView.snp.makeConstraints { make in
            make.top.equalTo(62)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 140, height: 104))
        }

        let textLabel = UILabel(text: prop.dsc, textColor: UIColor(hex: 0x000000), fontSize: 12, weight: .semibold)
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.textAlignment = .center
        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(176)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.lessThanOrEqualTo(buttonsStackView.snp.top).offset(-16)
        }

    }


    private func useBackpackProp() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        userProvider.request(.useBackpackProp(pptTp: prop.pptTp)) { result in
            hud.hide()
            switch result {
            case .success:
                self.presentingViewController?.dismiss(animated: true)
                NotificationCenter.default.post(name: .BackpackPropDidChangeNotification, object: nil)
                break
            case .failure(let error):
                ToastView.showToast(error.localizedDescription, in: self.view)
                break
            }
        }
    }


}
