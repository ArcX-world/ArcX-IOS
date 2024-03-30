//
// Created by MAC on 2023/11/22.
//

import UIKit

extension UIViewController {

    func findVisibleViewController() -> UIViewController {
        var vc: UIViewController? = nil
        if #available(iOS 13.0, *) {
            vc = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
        } else {
            vc = UIApplication.shared.keyWindow?.rootViewController
        }
        while let presentedViewController = vc?.presentedViewController {
            vc = presentedViewController
        }
        if vc is UINavigationController {
            if let lastVC = (vc as! UINavigationController).viewControllers.last {
                vc = lastVC
            }
        }
        return vc ?? self
    }

    func ensureAuth(then block: () -> Void) {
        if AccessToken.isActive {
            block()
        } else {
            present(LoginViewController(), animated: true)
        }
    }

}
