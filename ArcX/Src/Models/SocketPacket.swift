//
// Created by LLL on 2024/3/13.
//

import UIKit
import Foundation

struct SocketPacket: CustomStringConvertible {
    let cmd: Int
    let parameter: [String: Any]

    init(cmd: Int, parameter: [String: Any] = [:]) {
        self.cmd = cmd
        self.parameter = parameter
    }

    var description: String {
        var parameter = parameter

        var jsonObject: [String: Any] = [:]
        jsonObject["cmd"] = cmd
        jsonObject["param"] = parameter

        do {
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
            if let rawString = String(data: data, encoding: .utf8) {
                return rawString
            }
        } catch {
            print("\(#function)  \(error)")
        }
        return "\(jsonObject)"
    }
}
