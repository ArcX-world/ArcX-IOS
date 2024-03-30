//
// Created by LLL on 2024/3/22.
//

import Foundation

enum WalletToken: Int {
    case sol = 1
    case axc = 2
    case usdt = 3

    var icon: UIImage? {
        switch self {
        case .sol: return UIImage(named: "img_sol_token")
        case .axc: return UIImage(named: "img_axc_token")
        case .usdt: return UIImage(named: "img_usdt_token")
        }
    }

    var unit: String {
        switch self {
        case .sol: return "SOL"
        case .axc: return "AXC"
        case .usdt: return "USDT"
        }
    }

    static var allValues: [WalletToken] {
        return [ .sol, .axc, .usdt ]
    }

}
