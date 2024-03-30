//
// Created by MAC on 2023/12/1.
//

import Foundation

extension CGPoint {

    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }

}