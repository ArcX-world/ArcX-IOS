//
// Created by MAC on 2023/11/2.
//

import UIKit

class BaseViewController: UIViewController {

    lazy var bottomNavigationBar = BottomNavigationBar(title: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        logger.info("\(self)")

        if let navigationController = navigationController, navigationController.viewControllers.count > 1 {
            view.addSubview(bottomNavigationBar)
            bottomNavigationBar.snp.makeConstraints { (make) in
                make.left.equalToSuperview()
                make.bottom.equalTo(view.snp.bottomMargin).offset(-20)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bottomNavigationBar.titleLabel.text = title
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(bottomNavigationBar)
    }

    deinit {
        logger.info("\(self)")
    }

}
