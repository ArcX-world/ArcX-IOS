//
// Created by MAC on 2023/11/23.
//

import UIKit

private struct UIViewControllerAssociatedKeys {
    static var presentBlockArray: Void? = nil
}

extension UIViewController {

    @objc var isEnqueueForPresentation: Bool { return false }

    class func hookForPresentation() {
        method_exchangeImplementations(class_getInstanceMethod(Self.self, #selector(UIViewController.present(_:animated:completion:)))!,
                class_getInstanceMethod(Self.self, #selector(UIViewController.tp_present(_:animated:completion:)))!)

        method_exchangeImplementations(class_getInstanceMethod(Self.self, #selector(UIViewController.dismiss(animated:completion:)))!,
                class_getInstanceMethod(Self.self, #selector(UIViewController.tp_dismiss(animated:completion:)))!)
    }

    private var presentBlockArray: [() -> Void] {
        get {
            if let array = objc_getAssociatedObject(self, &UIViewControllerAssociatedKeys.presentBlockArray) as? [() -> Void] {
                return array
            }
            return []
        }
        set {
            objc_setAssociatedObject(self, &UIViewControllerAssociatedKeys.presentBlockArray, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    @objc private func tp_present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> ())? = nil) {
        if let presentedViewController = presentedViewController, viewControllerToPresent.isEnqueueForPresentation {
            let block = { self.tp_present(viewControllerToPresent, animated: flag, completion: completion) }

            if let realPresentingViewController = presentedViewController.presentingViewController {
                var blockArray = realPresentingViewController.presentBlockArray
                blockArray.append(block)
                realPresentingViewController.presentBlockArray = blockArray
            }
        } else {
            tp_present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }

    @objc private func tp_dismiss(animated flag: Bool, completion: (() -> ())? = nil) {
        tp_dismiss(animated: flag) {
            completion?()
            var blockArray = self.presentBlockArray
            if blockArray.count > 0 {
                let block = blockArray.remove(at: 0)
                self.presentBlockArray = blockArray
                block()
            }
        }
    }
}
