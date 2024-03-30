//
// Created by LLL on 2024/3/13.
//

import Moya

let machineProvider = DefaultProvider<MachineAPI>()

enum MachineAPI: TargetType {
    case getMachines(type: Int, pageNum: Int, pageSize: Int)
    case getMachine(id: Int)
    case getIdleMachine(category: Int)
    case getCurrentMachine

    var baseURL: URL {
        return URL(string: Constants.App.domain)!
    }

    var path: String {
        switch self {
        case .getMachines: return "/dev_tbln"
        case .getMachine: return "/dev_ifo"
        case .getIdleMachine: return "/fs_jn_dev"
        case .getCurrentMachine: return "/gm_dev"
        }
    }

    var method: Moya.Method {
        switch self {
        default: return .get
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .getMachines(let type, let pageNum, let pageSize):
            return [ "devTp": type, "pgNm": pageNum, "pgAmt": pageSize ]
        case .getMachine(let id):
            return [ "devId": id ]
        case .getIdleMachine(let category):
            return [ "devTp": category ]
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
