//
// Created by MAC on 2023/11/8.
//

import UIKit

class BasePopoverController: BaseViewController, UIPopoverPresentationControllerDelegate {

    var margin: UIEdgeInsets = .zero

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .popover
        popoverPresentationController?.delegate = self
        popoverPresentationController?.backgroundColor = .clear
        popoverPresentationController?.popoverBackgroundViewClass = _CustomPopoverBackgroundView.self
        popoverPresentationController?.permittedArrowDirections = .up
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.superview?.layer.cornerRadius = 0
        view.superview?.layer.borderWidth = 0

        for subview in popoverPresentationController!.containerView!.subviews {
            if NSStringFromClass(subview.classForCoder) == "_UICutoutShadowView" {
                subview.isHidden = true
            }
            for subview in subview.subviews {
                if NSStringFromClass(subview.classForCoder) == "_UICutoutShadowView" {
                    subview.isHidden = true
                }
            }
        }
    }

    // MARK: - UIPopoverPresentationControllerDelegate

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .popover
    }

    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationController(_ popoverPresentationController: UIPopoverPresentationController, willRepositionPopoverTo rect: UnsafeMutablePointer<CGRect>, in view: AutoreleasingUnsafeMutablePointer<UIView>) {
        popoverPresentationController.popoverLayoutMargins = margin
    }


    class _CustomPopoverBackgroundView: UIPopoverBackgroundView {

        override class func contentViewInsets() -> UIEdgeInsets {
            return .zero
        }

        override class func arrowBase() -> CGFloat {
            return 0
        }

        override class func arrowHeight() -> CGFloat {
            return 0
        }

        private var _arrowDirection: UIPopoverArrowDirection = .any
        override var arrowDirection: UIPopoverArrowDirection {
            get { return _arrowDirection }
            set {
                _arrowDirection = newValue
                setNeedsLayout()
            }
        }

        private var _arrowOffset: CGFloat = 0
        override var arrowOffset: CGFloat {
            get { _arrowOffset }
            set {
                _arrowOffset = newValue
                setNeedsLayout()
            }
        }

        override class var wantsDefaultContentAppearance: Bool {
            super.wantsDefaultContentAppearance
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            backgroundColor = .clear
            layer.shadowColor = UIColor.clear.cgColor
            layer.shadowRadius = 0
        }

    }
}
