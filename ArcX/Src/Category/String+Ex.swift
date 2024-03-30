//
// Created by MAC on 2023/11/14.
//

import Foundation
import CommonCrypto

extension String {

    var md5: String {
        let utf8 = cString(using: .utf8)
        var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(utf8, CC_LONG(utf8!.count - 1), &digest)
        return digest.reduce("") { $0 + String(format:"%02X", $1) }
    }

    func substring(from offset: Int) -> String {
        let start = index(startIndex, offsetBy: offset)
        return String(self[start...])
    }

    func substring(to offset: Int) -> String {
        let end = index(startIndex, offsetBy: offset)
        return String(self[..<end])
    }

    func appendingPathComponent(_ str: String) -> String {
        return (self as NSString).appendingPathComponent(str)
    }
}