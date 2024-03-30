//
// Created by MAC on 2023/12/11.
//

import UIKit

extension UIScrollView {

    fileprivate struct AssociatedKeys {
        static var header: Void? = nil
        static var footer: Void? = nil
    }

    var rf_contentInset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return adjustedContentInset
        }
        return contentInset
    }

    var rf_contentInsetTop: CGFloat {
        get { rf_contentInset.top }
        set {
            var inset = contentInset
            inset.top = newValue
            if #available(iOS 11.0, *) {
                inset.top -= (adjustedContentInset.top - contentInset.top)
            }
            contentInset = inset
        }
    }

    var rf_contentInsetLeft: CGFloat {
        get { rf_contentInset.left }
        set {
            var inset = contentInset
            inset.left = newValue
            if #available(iOS 11.0, *) {
                inset.left -= (adjustedContentInset.left - contentInset.left)
            }
            contentInset = inset
        }
    }

    var rf_contentInsetBottom: CGFloat {
        get { rf_contentInset.bottom }
        set {
            var inset = contentInset
            inset.bottom = newValue
            if #available(iOS 11.0, *) {
                inset.bottom -= (adjustedContentInset.bottom - contentInset.bottom)
            }
            contentInset = inset
        }
    }

    var rf_contentInsetRight: CGFloat {
        get { rf_contentInset.right }
        set {
            var inset = contentInset
            inset.right = newValue
            if #available(iOS 11.0, *) {
                inset.right -= (adjustedContentInset.right - contentInset.right)
            }
            contentInset = inset
        }
    }


    var rf_header: RefreshHeader? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.header) as? RefreshHeader }
        set {
            if rf_header != newValue {
                rf_header?.removeFromSuperview()
                if let header = newValue {
                    insertSubview(header, at: 0)
                }
                objc_setAssociatedObject(self, &AssociatedKeys.header, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }

    var rf_footer: RefreshFooter? {
        get { objc_getAssociatedObject(self, &AssociatedKeys.footer) as? RefreshFooter }
        set {
            if rf_footer != newValue {
                rf_footer?.removeFromSuperview()
                if let footer = newValue {
                    insertSubview(footer, at: 0)
                }
                objc_setAssociatedObject(self, &AssociatedKeys.footer, newValue, .OBJC_ASSOCIATION_RETAIN)
            }
        }
    }

}