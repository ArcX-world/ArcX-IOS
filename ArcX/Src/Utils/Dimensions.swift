//
// Created by MAC on 2023/11/2.
//

import UIKit

class Dimensions {

    static var designSize = CGSize(width: 375, height: 812)

    static let screenSize: CGSize = {
        let w = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        let h = max(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        return CGSize(width: w, height: h)
    }()

    static var WLR: CGFloat {
        return screenSize.width / designSize.width
    }

    static var HLR: CGFloat {
        return screenSize.height / designSize.height
    }

}
