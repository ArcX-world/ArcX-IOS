//
// Created by MAC on 2023/11/20.
//

import Foundation

extension KeyedDecodingContainer {

    public func decode(_ type: Bool.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> Bool {
        do {
            if let boolValue = try decodeIfPresent(Bool.self, forKey: key) {
                return boolValue
            }
        } catch {}
        let intValue = try decode(Int.self, forKey: key)
        return intValue != 0
    }

}