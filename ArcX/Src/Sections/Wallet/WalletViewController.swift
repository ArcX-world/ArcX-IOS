//
// Created by LLL on 2024/3/21.
//

import Foundation

class WalletViewController: BaseViewController {

    weak var selectedViewController: UIViewController? {
        didSet { setSelectedViewController(selectedViewController, oldSelectedViewController: oldValue) }
    }

    private let viewControllers: [UIViewController] = [
        SpendingWalletViewController(),
        BlockchainWalletViewController(),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }

    private func setSelectedViewController(_ selectedViewController: UIViewController?, oldSelectedViewController: UIViewController?) {
        if let oldSelectedViewController = oldSelectedViewController {
            oldSelectedViewController.beginAppearanceTransition(false, animated: false)
            oldSelectedViewController.willMove(toParent: nil)
            oldSelectedViewController.view.removeFromSuperview()
            oldSelectedViewController.removeFromParent()
            oldSelectedViewController.endAppearanceTransition()
        }

        if let selectedViewController = selectedViewController {
            selectedViewController.beginAppearanceTransition(true, animated: false)
            addChild(selectedViewController)
            selectedViewController.view.frame = view.bounds
            selectedViewController.view.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
            selectedViewController.willMove(toParent: self)
            view.insertSubview(selectedViewController.view, at: 0)
            selectedViewController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            selectedViewController.didMove(toParent: self)
            selectedViewController.endAppearanceTransition()
        }
    }

    @objc private func segmentedControlValueChange(_ sender: SegmentedControl) {
        selectedViewController = viewControllers[sender.selectedSegmentIndex]
    }

    // MARK: - Private

    private func commonInit() {
        title = "Wallet"
        view.layer.contents = UIImage.gradient(colors: [ UIColor(hex: 0xC6B1FF), UIColor(hex: 0xFFEDE0), UIColor(hex: 0xDDC6F6), UIColor(hex: 0x8A8DCF)  ], locations: nil, size: view.frame.size, start: CGPoint(), end: CGPoint(x: 0, y: 1)).cgImage

        let segmentedControl = SegmentedControl(items: viewControllers.map({ $0.title ?? "" }))
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChange(_:)), for: .valueChanged)
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }

        DispatchQueue.main.async {
            segmentedControl.selectedSegmentIndex = 0
        }

    }


}
