//
// Created by LLL on 2024/2/26.
//

import UIKit

class TouchableView: UIView {

    var isTouchable: Bool = true

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == self && !isTouchable {
            return nil
        }
        return hitView
    }
}
