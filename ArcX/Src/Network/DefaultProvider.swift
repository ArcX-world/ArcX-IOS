//
// Created by MAC on 2023/11/14.
//

import Moya
import UIKit

class DefaultProvider<Target: TargetType>: MoyaProvider<Target> {

    init() {
        super.init(plugins: [ TimeoutPlugin(), HeaderPlugin(), LoggerPlugin(), StatusPlugin() ])
    }
}


private class TimeoutPlugin: PluginType {

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        request.timeoutInterval = target.timeoutInterval
        return request
    }

}

private class HeaderPlugin: PluginType {

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }

}

private class LoggerPlugin: PluginType {

    func willSend(_ request: RequestType, target: TargetType) {
        var string = "[HTTP] \(target.method.rawValue) >>> \(target.path)  -  "
        if let query = request.request?.url?.query, query.count > 0 {
            string += "\(query) "
        }
        if let httpBody = request.request?.httpBody, let json = String(data: httpBody, encoding: .utf8), json.count > 0 {
            string += "\(json)"
        }
        logger.info(string, fileName: "")
    }

    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            let responseString = (try? response.mapString()) ?? ""
            logger.info("[HTTP] \(target.method.rawValue) <<< \(target.path)  -  \(responseString)", fileName: "")
            break
        case .failure(let error):
            logger.info("[HTTP] \(target.method.rawValue) <<< \(target.path)  -  \(error)", fileName: "")
            break
        }
    }

}

private class StatusPlugin: PluginType {

    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        if case .success(let response) = result {
            do {
                let status = try response.map(Int.self, atKeyPath: "errorCode")
                let errorMsg = try response.map(String.self, atKeyPath: "errorDesc")
                if status != 1 {
                    return .failure(.underlying(APIError(code: status, description: errorMsg), response))
                }
            } catch {

            }
        }
        return result
    }

}


class APIError: Error, LocalizedError {

    let code: Int
    let description: String

    init(code: Int, description: String) {
        self.code = code
        self.description = description
    }

    var errorDescription: String? {
        return description
    }

}

extension TargetType {

    var timeoutInterval: TimeInterval { return 10 }

}
