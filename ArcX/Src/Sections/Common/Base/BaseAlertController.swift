//
// Created by MAC on 2023/11/3.
//

import UIKit

class BaseAlertController: BaseViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    var isTapDismiss: Bool = false

    var maskView: UIView!

    var onDismissed: (() -> Void)?

    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        maskView = UIView(frame: view.bounds)
        maskView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.7)

        if isTapDismiss {
            let gestureView = UIView(frame: view.bounds)
            gestureView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gestureViewTap)))
            view.insertSubview(gestureView, at: 0)
        }

    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            onDismissed?()
            onDismissed = nil
        }
    }

    // MARK: - Private

    @objc func gestureViewTap() {
        presentingViewController?.dismiss(animated: true)
    }

    // MARK: - UIViewControllerTransitioningDelegate

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    // MARK: - UIViewControllerAnimatedTransitioning

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if isBeingPresented {
            return 0.35
        }
        return 0.15
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if isBeingPresented {
            let containerView = transitionContext.containerView
            containerView.addSubview(maskView)

            let toView = transitionContext.view(forKey: .to)!
            containerView.addSubview(toView)

            maskView.alpha = 0.6
            let targetTransform = toView.transform
            toView.alpha = 0.6
            toView.transform = CGAffineTransform.identity.scaledBy(x: 1.25, y: 1.25)
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                self.maskView.alpha = 1.0
                toView.alpha = 1.0
                toView.transform = targetTransform
            }, completion: { b in
                transitionContext.completeTransition(true)
            })
        }
        else if isBeingDismissed {
            let containerView = transitionContext.containerView

            if let toView = transitionContext.view(forKey: .to) {
                containerView.addSubview(toView)
            }
            guard let fromView = transitionContext.view(forKey: .from) else {
                transitionContext.completeTransition(true)
                return
            }
            containerView.addSubview(fromView)

            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
                self.maskView.alpha = 0.0
                fromView.alpha = 0.0
                fromView.transform = CGAffineTransform.identity.scaledBy(x: 0.6, y: 0.6)
            }, completion: { b in
                transitionContext.completeTransition(true)
            })
        }
    }

}
