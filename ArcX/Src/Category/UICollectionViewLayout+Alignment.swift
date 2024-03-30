//
// Created by MAC on 2023/11/2.
//

import UIKit

extension UICollectionViewLayout {

    var alignment: NSTextAlignment {
        get { NSTextAlignment.left }
        set {
            let selector = NSSelectorFromString("_setRowAlignmentsOptions:")
            if responds(to: selector) {
                let params = NSDictionary(dictionary: [
                    "UIFlowLayoutCommonRowHorizontalAlignmentKey": NSNumber(value: newValue.rawValue),
                    "UIFlowLayoutLastRowHorizontalAlignmentKey": NSNumber(value: newValue.rawValue),
                    "UIFlowLayoutRowVerticalAlignmentKey": NSNumber(value: newValue.rawValue),
                ])
                self.perform(selector, with: params)
            }
        }
    }

}