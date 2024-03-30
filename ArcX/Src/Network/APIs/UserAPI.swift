//
// Created by LLL on 2024/3/13.
//

import Moya

let userProvider = DefaultProvider<UserAPI>()

enum UserAPI: TargetType {
    case userinfo
    case updateUserinfo(nickname: String, gender: Int)
    case upgradeAttribute(type: Int)
    case getBackpackNFTs(pageNum: Int, pageSize: Int)
    case getBackpackProps(pageNum: Int, pageSize: Int)
    case useBackpackProp(pptTp: Int)


    var baseURL: URL {
        return URL(string: Constants.App.domain)!
    }

    var path: String {
        switch self {
        case .userinfo: return "/ply_ifo"
        case .updateUserinfo: return "/ud_ply_ifo"
        case .upgradeAttribute: return "/upg_atb"
        case .getBackpackNFTs: return "/nft_kpk"
        case .getBackpackProps: return "/ppt_kpk"
        case .useBackpackProp: return "/use_ppt"
        }
    }

    var method: Moya.Method {
        switch self {
        case .updateUserinfo: return .post
        case .upgradeAttribute: return .post
        case .useBackpackProp: return .post
        default: return .get
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .updateUserinfo(let nickname, let gender):
            return [ "plyNm": nickname, "sex": gender ]
        case .upgradeAttribute(let type):
            return [ "atbTp": type ]
        case .getBackpackNFTs(let pageNum, let pageSize):
            return [ "pgNm": pageNum, "pgAmt": pageSize ]
        case .getBackpackProps(let pageNum, let pageSize):
            return [ "pgNm": pageNum, "pgAmt": pageSize ]
        case .useBackpackProp(let pptTp):
            return [ "pptTp": pptTp ]
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
