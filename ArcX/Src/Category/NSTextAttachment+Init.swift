//
// Created by MAC on 2023/11/21.
//

import UIKit

extension NSTextAttachment {

    convenience init(image: UIImage, bounds: CGRect) {
        self.init()
        self.image = image
        self.bounds = bounds
    }

}
