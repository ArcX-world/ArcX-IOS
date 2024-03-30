//
// Created by LLL on 2024/3/23.
//

import UIKit

class LaunchViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        let imageView = UIImageView(image: UIImage(named: "img_root_launch"))
        imageView.sizeToFit()
        imageView.center = view.center
        view.addSubview(imageView)
    }


    func fadeIn(toParent parentViewController: UIViewController) {
        beginAppearanceTransition(true, animated: false)
        parentViewController.addChild(self)
        view.frame = view.bounds
        view.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        willMove(toParent: parentViewController)
        parentViewController.view.addSubview(view)
        didMove(toParent: parentViewController)
        endAppearanceTransition()
    }

    func fadeOut(completion: @escaping () -> Void) {
        UIView.animate(withDuration: 0.7, delay: 1, options: .curveEaseInOut, animations: {
            self.view.alpha = 0
        }, completion: { b in
            self.beginAppearanceTransition(false, animated: false)
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
            self.endAppearanceTransition()
            completion()
        })
    }

}
