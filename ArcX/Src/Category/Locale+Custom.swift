//
// Created by MAC on 2024/1/9.
//

import Foundation

extension Locale {

    static var custom: Locale = {
        return Locale.current
    }()

    var minimalIdentifier: String {
        if let languageCode = languageCode {
            if let scriptCode = scriptCode {
                return "\(languageCode)-\(scriptCode)"
            }
            return languageCode
        }
        return identifier
    }

}