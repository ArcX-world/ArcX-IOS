//
// Created by MAC on 2023/11/15.
//

import Foundation

extension Encodable {

    func toJSONObject() -> Any? {
        if let data = try? JSONEncoder().encode(self), let jsonObject = try? JSONSerialization.jsonObject(with: data) {
            return jsonObject
        }
        return nil
    }

    func toJSONString() -> String? {
        if let data = try? JSONEncoder().encode(self), let jsonString = String(data: data, encoding: .utf8) {
            return jsonString
        }
        return nil
    }
}

extension Decodable {

    static func from(json: Any?) -> Self? {
        guard let json = json else {
            return nil
        }
        do {
            if let data = json as? Data {
                return try decode(from: data)
            }
            if let str = json as? String, let data = str.data(using: .utf8) {
                return try decode(from: data)
            }
            let data = try JSONSerialization.data(withJSONObject: json)
            return try decode(from: data)
        } catch {
            logger.error(error)
        }
        return nil
    }

    private static func decode(from data: Data) throws -> Self?  {
        let decoder = JSONDecoder()
        return try decoder.decode(Self.self, from: data)
    }

}