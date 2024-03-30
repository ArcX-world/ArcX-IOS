//
// Created by MAC on 2023/11/25.
//

import Moya

let basicProvider = DefaultProvider<BasicAPI>()

enum BasicAPI: TargetType {
    case getProxyMsg
    case getRechargeProducts
    case getCheckinMsg
    case checkin
    case getBanners
    case feedback(content: String)

    case purchase(parameter: [String: Any])
    case verify(orderSn: String, transactionId: String, payload: String)


    var baseURL: URL {
        return URL(string: Constants.App.domain)!
    }

    var path: String {
        switch self {
        case .getProxyMsg: return "/ag_ifo"
        case .getRechargeProducts: return "/recharge_list"
        case .getCheckinMsg: return "/sign_msg"
        case .checkin: return "/receive_sign_award"
        case .getBanners: return "/carousel_info"
        case .feedback: return "/user_opinion"
        case .purchase: return "/ap_od"
        case .verify: return "/ap_vrf"
        default: return "/FFFF"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getProxyMsg: return .post
        case .purchase, .verify: return .post
        case .checkin: return .post
        case .feedback: return .post
        default: return .get
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .feedback(let content):
            return [ "opinionMsg": content ]
        case .purchase(let parameter):
            return parameter
        case .verify(let orderSn, let transactionId, let payload):
            return [ "odNo": orderSn, "tsNo": transactionId, "vfDt": payload ]
        default:
            return [:]
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
