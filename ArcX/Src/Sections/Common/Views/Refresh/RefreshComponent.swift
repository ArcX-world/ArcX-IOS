//
// Created by MAC on 2023/12/11.
//

import UIKit

class RefreshComponent: UIView {

    enum State {
        case idle
        case pulling
        case refreshing
        case willRefresh
        case noMore
    }

    var state: State = .idle {
        didSet { setNeedsDisplay() }
    }

    var pullingPercent: CGFloat = 0

    var isRefreshing: Bool {
        return state == .refreshing || state == .willRefresh
    }

    private var refreshingTarget: Any?
    private var refreshingAction: Selector?

    var originalScrollViewInsets: UIEdgeInsets = UIEdgeInsets.zero
    weak var scrollView: UIScrollView!
    private weak var pan: UIPanGestureRecognizer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        removeObservers()
        guard let newSuperview = newSuperview, newSuperview is UIScrollView else {
            return
        }

        scrollView = newSuperview as! UIScrollView
        scrollView.alwaysBounceVertical = true
        originalScrollViewInsets = scrollView.rf_contentInset

        frame.size.width = scrollView.frame.size.width
        frame.origin.x = scrollView.rf_contentInset.left

        addObservers()
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        if state == .willRefresh {
            state = .refreshing
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        //super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        if !isUserInteractionEnabled {
            return
        }
        if keyPath == #keyPath(UIScrollView.contentSize) {
            scrollViewContentSizeDidChange(change)
        }
        if isHidden {
            return
        }
        if keyPath == #keyPath(UIScrollView.contentOffset) {
            scrollViewContentOffsetDidChange(change)
        } else if keyPath == "state" {
            scrollViewPanStateDidChange(change)
        }
    }

    // MARK: - Public

    func prepare() {
        backgroundColor = UIColor.clear
        autoresizingMask = .flexibleWidth
    }

    func setRefreshingTarget(_ target: Any?, action: Selector?) {
        refreshingTarget = target
        refreshingAction = action
    }

    func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey: Any]?) {

    }

    func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey: Any]?) {

    }

    func scrollViewPanStateDidChange(_ change: [NSKeyValueChangeKey: Any]?) {

    }

    func beginRefreshing() {
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1.0
        }

        pullingPercent = 1.0
        if window != nil {
            state = .refreshing
        } else {
            if state != .refreshing {
                state = .willRefresh
                setNeedsDisplay()
            }
        }
    }

    func endRefreshing() {
        state = .idle
    }

    func executeRefreshingCallback() {
        if let target = refreshingTarget as? NSObject, let selector = refreshingAction {
            target.perform(selector, with: target)
//            if let method = class_getInstanceMethod(target.classForCoder, selector) {
//                let imp = method_getImplementation(method)
//                typealias Function = @convention(c) (AnyObject, Selector, Any?) -> ();
//                let function = unsafeBitCast(imp, to: Function.self);
//                function(target, selector, self);
//            }
        }
    }


    // MARK: - Private

    private func addObservers() {
        let options: NSKeyValueObservingOptions = [ .new, .old ]
        scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset), options: options, context: nil)
        scrollView.addObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize), options: options, context: nil)
        //scrollView.observeValue(forKeyPath: #keyPath(UIScrollView.contentOffset), of: self, change: <#T##[NSKeyValueChangeKey: Any]?##[Foundation.NSKeyValueChangeKey: Any]?#>, context: <#T##UnsafeMutableRawPointer?##Swift.UnsafeMutableRawPointer?#>)
        pan = scrollView.panGestureRecognizer
        pan.addObserver(self, forKeyPath: "state", options: options, context: nil)
    }

    private func removeObservers() {
        superview?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentOffset))
        superview?.removeObserver(self, forKeyPath: #keyPath(UIScrollView.contentSize))
        pan?.removeObserver(self, forKeyPath: "state")
        pan = nil
    }



}