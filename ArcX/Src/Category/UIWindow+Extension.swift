//
// Created by MAC on 2024/2/20.
//

import UIKit

extension UIWindow {

    func findTopViewController<T>(of cls: T.Type) -> T? {
        guard let rootViewController = rootViewController else { return nil }

        var viewControllers: [UIViewController] = [ rootViewController ]
        var viewController: UIViewController = rootViewController
        while let presentedViewController = viewController.presentedViewController {
            viewControllers.append(presentedViewController)
            viewController = presentedViewController
        }
        if viewController is UINavigationController {
            viewControllers += (viewController as! UINavigationController).viewControllers
        }
        for vc in viewControllers.reversed() {
            if let result = vc as? T {
                return result
            }
        }
        return nil
    }

}
