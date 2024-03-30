//
// Created by MAC on 2023/11/3.
//

import Foundation

extension NSNumber {

    func formatted(style: NumberFormatter.Style) -> String {
        let fmt = NumberFormatter()
        fmt.numberStyle = style
        fmt.minimumFractionDigits = 0
        fmt.maximumFractionDigits = 9
        return fmt.string(from: self) ?? "\(doubleValue)"
    }
}