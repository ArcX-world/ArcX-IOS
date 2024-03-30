//
// Created by MAC on 2023/11/14.
//

import UIKit
import KeychainAccess

extension UIDevice {

    static private let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
            .accessibility(.always)
            .synchronizable(false)

    var identifier: UUID {
        if let string = try? UIDevice.keychain.getString("arcx_identifier") {
            if let uuid = UUID(uuidString: string) {
                return uuid
            }
        }
        let uuid = UUID()
        try? UIDevice.keychain.set(uuid.uuidString, key: "arcx_identifier")
        return uuid
    }

}
