//
// Created by MAC on 2023/12/11.
//

import UIKit

class RefreshNormalHeader: RefreshHeader {

    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: .gray)
        loadingView.hidesWhenStopped = false
        addSubview(loadingView)
        return loadingView
    }()

    override var state: State {
        get { super.state }
        set {
            let oldState = state
            if oldState == newValue { return }
            super.state = newValue
            if state == .idle {
                loadingView.stopAnimating()
            } else if state == .pulling {
                loadingView.stopAnimating()
            } else if state == .refreshing {
                loadingView.startAnimating()
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        loadingView.center = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
    }
}
