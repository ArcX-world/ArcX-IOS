//
// Created by LLL on 2024/3/22.
//

import Moya

let walletProvider = DefaultProvider<WalletAPI>()

enum WalletAPI: TargetType {
    case getSpendingWallet
    case getBlockchainWallet
    case transferWallet(tokenType: Int, amount: Double)
    case transferSpending(tokenType: Int, amount: Double)
    case getConfiguration


    var baseURL: URL {
        return URL(string: Constants.App.domain)!
    }

    var path: String {
        switch self {
        case .getSpendingWallet: return "/wl_spd"
        case .getBlockchainWallet: return "/chn_wl"
        case .transferWallet: return "/wl_wtd"
        case .transferSpending: return "/wl_rcg"
        case .getConfiguration: return "/wl_cfg"
        }
    }

    var method: Moya.Method {
        switch self {
        case .transferWallet: return .post
        case .transferSpending: return .post
        default: return .get
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .transferWallet(let tokenType, let amount):
            return [ "tkTp": tokenType, "amt": amount ]
        case .transferSpending(let tokenType, let amount):
            return [ "tkTp": tokenType, "amt": amount ]
        default: return [:]
        }
    }

    var task: Task {
        var encoding: ParameterEncoding = URLEncoding.default
        if case .post = method {
            encoding = JSONEncoding.default
        }
        return .requestParameters(parameters: parameters, encoding: encoding)
    }

    var headers: [String: String]? {
        return nil
    }
}
