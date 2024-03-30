//
// Created by LLL on 2024/2/22.
//

import UIKit

class ProgressHUD: UIView {

    let loadingView = UIActivityIndicatorView(style: .gray)

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadingView.hidesWhenStopped = true
        addSubview(loadingView)
        loadingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func showHUD(addedTo view: UIView) {
        frame = view.bounds
        view.addSubview(self)
        loadingView.startAnimating()

//        loadingView.alpha = 0.0
//        UIView.animate(withDuration: 0.25, delay: 0.8, options: .curveLinear) {
//            self.loadingView.alpha = 1.0
//        }
    }

    func hide() {
        loadingView.stopAnimating()
        removeFromSuperview()
    }

    class func showHUD(addedTo view: UIView) -> ProgressHUD {
        let hud = ProgressHUD(frame: view.bounds)
        hud.showHUD(addedTo: view)
        return hud
    }
}
