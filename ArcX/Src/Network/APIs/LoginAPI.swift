//
// Created by LLL on 2024/2/22.
//

import Moya

let loginProvider = DefaultProvider<LoginAPI>()

enum LoginAPI: TargetType {
    case guestLogin
    case appleIDLogin(code: String)
    case refreshToken(token: String)
    case logout
    case sendCode(email: String)
    case emailLogin(email: String, code: String?, password: String?)

    var baseURL: URL {
        return URL(string: Constants.App.domain)!
    }

    var path: String {
        switch self {
        case .guestLogin: return "/ply_log_on"
        case .appleIDLogin: return "/ply_log_on"
        case .refreshToken: return "/ref_voucher"
        case .logout: return "/lgo_act"
        case .sendCode: return "/em_vrf_cd"
        case .emailLogin: return "/ply_log_on"
        }
    }

    var method: Moya.Method {
        return .post
    }

    var parameters: [String: Any] {
        switch self {
        case .guestLogin: return [ "lgWt": 1 ]
        case .appleIDLogin(let code): return [ "lgWt": 2, "iosToken": code ]
        case .refreshToken(let token): return [ "refTkn": token ]
        case .sendCode(let email):
            return [ "email": email ]
        case .emailLogin(let email, let code, let password):
            var parameters: [String: Any] = [ "lgWt": 3, "email": email ]
            parameters["vfyCd"] = code
            parameters["pwd"] = password
            return parameters
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
