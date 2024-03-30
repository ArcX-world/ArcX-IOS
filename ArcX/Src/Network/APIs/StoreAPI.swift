//
// Created by LLL on 2024/3/20.
//

import Moya

let storeProvider = DefaultProvider<StoreAPI>()

enum StoreAPI: TargetType {
    case getStoreMsg
    case purchase(type: Int, cmdId: Int?, devId: Int?)  //type 1、超级玩家 2、金币 3、道具

    var baseURL: URL {
        return URL(string: Constants.App.domain)!
    }

    var path: String {
        switch self {
        case .getStoreMsg: return "/shp_mal"
        case .purchase: return "/cmd_dr_puc"
        }
    }

    var method: Moya.Method {
        return .post
    }

    var parameters: [String: Any] {
        switch self {
        case .purchase(let type, let cmdId, let devId):
            var parameters: [String: Any] = [ "rcgCmdTp": type ]
            parameters["cmdId"] = cmdId
            parameters["devId"] = devId
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
