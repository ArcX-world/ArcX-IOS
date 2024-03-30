//
// Created by LLL on 2024/3/27.
//

import UIKit
import SwiftyJSON

class BackpackViewController: BaseViewController {

    private lazy var navigationBar = UserNavigationBar()

    private let viewControllers: [UIViewController] = [
        BackpackNFTsViewController(),
        BackpackPropsViewController()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }


    // MARK: - Private

    @objc private func segmentedControlValueChange(_ sender: NFTSegmentedControl) {
        let childViewController = viewControllers[sender.selectedSegmentIndex]

        for i in 0..<viewControllers.count {
            if i != sender.selectedSegmentIndex && viewControllers[i].isViewLoaded {
                viewControllers[i].view.isHidden = true
            }
        }

        if childViewController.parent == nil {
            childViewController.beginAppearanceTransition(true, animated: false)
            addChild(childViewController)
            childViewController.view.frame = view.bounds
            childViewController.view.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
            childViewController.willMove(toParent: self)
            view.addSubview(childViewController.view)
            childViewController.didMove(toParent: self)
            childViewController.endAppearanceTransition()
            childViewController.view.snp.makeConstraints { make in
                make.top.equalTo(sender.snp.bottom)
                make.left.bottom.right.equalToSuperview()
            }
        }
        childViewController.view.isHidden = false
    }

    private func commonInit() {
        title = "NFT"

        let bgView = UIImageView(image: UIImage(named: "img_main_blur_bg"))
        bgView.frame = view.bounds
        view.addSubview(bgView)

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.equalToSuperview()
        }


        let segmentedControl = NFTSegmentedControl(items: [ "NFT", "PROP" ])
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChange(_:)), for: .valueChanged)
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }

        DispatchQueue.main.async {
            segmentedControl.selectedSegmentIndex = 0
        }


        let maskView = UIImageView()
        maskView.image = UIImage.gradient(colors: [ UIColor(hex: 0x000000, alpha: 0.5), UIColor(hex: 0x000000, alpha: 0) ],
                size: CGSize(width: view.frame.width, height: 500),
                end: CGPoint(x: 0, y: 1))
        view.insertSubview(maskView, belowSubview: segmentedControl)
        maskView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl)
            make.left.equalToSuperview()
        }

    }


}


