//
// Created by MAC on 2023/12/11.
//

import UIKit

private let RefreshHeaderRefreshing2IdleBoundsKey = "RefreshHeaderRefreshing2IdleBoundsKey"
private let RefreshHeaderRefreshingBounds = "RefreshHeaderRefreshingBounds"

class RefreshHeader: RefreshComponent, CAAnimationDelegate {


    override var state: State {
        get { super.state }
        set {
            let oldState = state
            if oldState == newValue { return }
            super.state = newValue
            if newValue == .idle {
                if oldState != .refreshing { return }
                handleEndingAction()
            } else if newValue == .refreshing {
                handleRefreshingAction()
            }
        }
    }

    var isCollectionViewAnimationBug: Bool = false

    private var insetTopDelta: CGFloat = 0

    init(target: Any, action: Selector?) {
        super.init(frame: CGRect(x: 0, y: 0, width: 375, height: 54))
        setRefreshingTarget(target, action: action)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func prepare() {
        super.prepare()
        frame.size.height = 54
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        frame.origin.y = -frame.size.height
    }

    // MARK: -

    private func resetContentInset() {
        if #available(iOS 11.0, *) {

        } else {
            if window == nil { return }
        }

        var insetTop = -scrollView.contentOffset.y > originalScrollViewInsets.top ? -scrollView.contentOffset.y : originalScrollViewInsets.top
        insetTop = insetTop > frame.size.height + originalScrollViewInsets.top ? frame.size.height + originalScrollViewInsets.top : insetTop
        insetTopDelta = originalScrollViewInsets.top - insetTop

        if fabs(scrollView.rf_contentInsetTop - insetTop) > CGFLOAT_EPSILON {
            scrollView.rf_contentInsetTop = insetTop
        }
    }

    // MARK: - Override

    override func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey: Any]?) {
        super.scrollViewContentSizeDidChange(change)
    }

    override func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey: Any]?) {
        super.scrollViewContentOffsetDidChange(change)

        if state == .refreshing {
            resetContentInset()
            return
        }

        originalScrollViewInsets = scrollView.rf_contentInset

        let offsetY = scrollView.contentOffset.y
        let happenOffsetY = originalScrollViewInsets.top


        if offsetY > happenOffsetY {
            return
        }

        let normal2PullingOffsetY = happenOffsetY - frame.size.height
        let pullingPercent = (happenOffsetY - offsetY) / frame.size.height
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            if state == .idle && offsetY < normal2PullingOffsetY {
                state = .pulling
            } else if state == .pulling && offsetY >= normal2PullingOffsetY {
                state = .idle
            }
        } else if state == .pulling {
            beginRefreshing()
        } else if pullingPercent < 1.0 {
            self.pullingPercent = pullingPercent
        }
    }

    // MARK: - Private

    private func handleRefreshingAction() {
        if !isCollectionViewAnimationBug {
            UIView.animate(withDuration: 0.25, animations: {
                if self.scrollView.panGestureRecognizer.state != .cancelled {
                    let top = self.originalScrollViewInsets.top + self.frame.size.height
                    self.scrollView.rf_contentInsetTop = top

                    var offset = self.scrollView.contentOffset
                    offset.y = -top
                    self.scrollView.setContentOffset(offset, animated: false)
                }
            }, completion: { b in
                self.executeRefreshingCallback()
            })
            return
        }

        if scrollView.panGestureRecognizer.state != .cancelled {
            let top = originalScrollViewInsets.top + frame.size.height
            scrollView.isUserInteractionEnabled = false

            let boundsAnimation = CABasicAnimation(keyPath: "bounds")
            var bounds = scrollView.bounds
            bounds.origin.y = -top
            boundsAnimation.fromValue = NSValue(cgRect: scrollView.bounds)
            boundsAnimation.toValue = NSValue(cgRect: bounds)
            boundsAnimation.duration = 0.25
            boundsAnimation.isRemovedOnCompletion = false
            boundsAnimation.fillMode = .both
            boundsAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            boundsAnimation.delegate = self
            boundsAnimation.setValue(RefreshHeaderRefreshingBounds, forKey: "identity")
            scrollView.layer.add(boundsAnimation, forKey: RefreshHeaderRefreshingBounds)
        } else {
            executeRefreshingCallback()
        }
    }

    private func handleEndingAction() {
        if !isCollectionViewAnimationBug {
            UIView.animate(withDuration: 0.4, animations: {
                logger.info("self.scrollView.rf_contentInsetTop: \(self.scrollView.rf_contentInsetTop)  self.insetTopDelta: \(self.insetTopDelta)")
                self.scrollView.rf_contentInsetTop += self.insetTopDelta
            }, completion: { b in
                self.pullingPercent = 0
            })
            return
        }

        scrollView.rf_contentInsetTop += insetTopDelta
        scrollView.isUserInteractionEnabled = false

        let boundsAnimation = CABasicAnimation(keyPath: "bounds")
        boundsAnimation.fromValue = NSValue(cgRect: scrollView.bounds.offsetBy(dx: 0, dy: insetTopDelta))
        //boundsAnimation.toValue = NSValue(cgRect: bounds)
        boundsAnimation.duration = 0.25
        boundsAnimation.isRemovedOnCompletion = false
        boundsAnimation.fillMode = .both
        boundsAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        boundsAnimation.delegate = self
        boundsAnimation.setValue(RefreshHeaderRefreshing2IdleBoundsKey, forKey: "identity")
        scrollView.layer.add(boundsAnimation, forKey: RefreshHeaderRefreshing2IdleBoundsKey)

    }


    // MARK: - CAAnimationDelegate

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let identity = anim.value(forKey: "identity") as! String
        if identity == RefreshHeaderRefreshing2IdleBoundsKey {
            pullingPercent = 0
            scrollView.isUserInteractionEnabled = true
        } else if identity == RefreshHeaderRefreshingBounds {
            if state != .idle {
                let top = originalScrollViewInsets.top + frame.size.height
                scrollView.rf_contentInsetTop = top

                var offset = scrollView.contentOffset
                offset.y = -top
                scrollView.setContentOffset(offset, animated: false)
            }
            scrollView.isUserInteractionEnabled = true
            executeRefreshingCallback()
        }

        if let _ = scrollView.layer.animation(forKey: RefreshHeaderRefreshingBounds) {
            scrollView.layer.removeAnimation(forKey: RefreshHeaderRefreshingBounds)
        }
        if let _ = scrollView.layer.animation(forKey: RefreshHeaderRefreshing2IdleBoundsKey) {
            scrollView.layer.removeAnimation(forKey: RefreshHeaderRefreshing2IdleBoundsKey)
        }

    }
}
