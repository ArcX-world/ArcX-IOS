//
// Created by MAC on 2023/12/12.
//

import UIKit

class RefreshNormalFooter: RefreshFooter {

    var automaticallyRefresh: Bool = true

    lazy var loadingView: UIActivityIndicatorView = {
        let loadingView = UIActivityIndicatorView(style: .gray)
        loadingView.hidesWhenStopped = true
        addSubview(loadingView)
        return loadingView
    }()

    private var triggerByDrag: Bool = false
    private var leftTriggerTimes: Int = 0

    override var state: State {
        get { super.state }
        set {
            let oldState = state
            if oldState == newValue { return }
            super.state = newValue

            if state == .refreshing {
                executeRefreshingCallback()
            } else if state == .noMore || state == .idle {
                if triggerByDrag {
                    leftTriggerTimes -= 1
                    triggerByDrag = false
                }
                if oldState == .refreshing {
                    if scrollView.isPagingEnabled {
                        var offset = scrollView.contentOffset
                        offset.y -= scrollView.rf_contentInsetBottom
                        UIView.animate(withDuration: 0.4, animations: {
                            self.scrollView.contentOffset = offset
                        }, completion: { b in

                        })
                        return
                    }

                }
            }

            if state == .noMore || state == .idle {
                loadingView.stopAnimating()
            } else if state == .refreshing {
                loadingView.startAnimating()
            }
        }
    }

    override var isHidden: Bool {
        get { super.isHidden }
        set {
            let oldValue = isHidden
            super.isHidden = newValue
            if !oldValue && newValue {
                state = .idle
                scrollView.rf_contentInsetBottom -= frame.size.height
            } else if oldValue && !newValue {
                scrollView.rf_contentInsetBottom += frame.size.height
                frame.origin.y = scrollView.contentSize.height
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        loadingView.center = CGPoint(x: frame.size.width * 0.5, y: frame.size.height * 0.5)
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if let newSuperview = newSuperview {
            if !isHidden {
                scrollView.rf_contentInsetBottom += frame.size.height
            }
            frame.origin.y = scrollView.contentSize.height
        } else {
            if !isHidden {
                scrollView.rf_contentInsetBottom -= frame.size.height
            }
        }
    }

    override func prepare() {
        super.prepare()
        automaticallyRefresh = true
    }

    override func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey: Any]?) {
        super.scrollViewContentSizeDidChange(change)

        let size = (change![.newKey] as! NSValue).cgSizeValue
        let contentHeight = size.height == 0 ? scrollView.contentSize.height : size.height
        if frame.origin.y != contentHeight {
            frame.origin.y = contentHeight
        }
    }

    override func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey: Any]?) {
        super.scrollViewContentOffsetDidChange(change)

        if state != .idle || !automaticallyRefresh || frame.origin.y == 0 {
            return
        }

        if scrollView.rf_contentInsetTop + scrollView.contentSize.height > scrollView.frame.size.height {
            if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height + frame.size.height + scrollView.rf_contentInsetBottom - frame.size.height {
                let old = (change![.oldKey] as! NSValue).cgPointValue
                let new = (change![.newKey] as! NSValue).cgPointValue
                if new.y <= old.y {
                    return
                }
                if scrollView.isDragging {
                    triggerByDrag = true
                }
                beginRefreshing()
            }
        }
    }

    override func scrollViewPanStateDidChange(_ change: [NSKeyValueChangeKey: Any]?) {
        super.scrollViewPanStateDidChange(change)
        if state != .idle {
            return
        }

        let panState = scrollView.panGestureRecognizer.state
        switch panState {
        case .ended:
            if scrollView.rf_contentInsetTop + scrollView.contentSize.height <= scrollView.frame.size.height {
                if scrollView.contentOffset.y >= -scrollView.rf_contentInsetTop {
                    triggerByDrag = true
                    beginRefreshing()
                }
            } else {
                if scrollView.contentOffset.y >= scrollView.contentSize.height + scrollView.rf_contentInsetBottom - scrollView.frame.size.height {
                    triggerByDrag = true
                    beginRefreshing()
                }
            }
            break
        case .began:
            leftTriggerTimes = 1
            break
        default:
            break
        }
    }

    override func beginRefreshing() {
        if triggerByDrag && leftTriggerTimes <= 0 {
            return
        }
        super.beginRefreshing()
    }
}
