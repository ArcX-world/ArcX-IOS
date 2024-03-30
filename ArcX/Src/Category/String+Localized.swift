//
// Created by MAC on 2024/1/9.
//

import Foundation

extension String {

    func localized(using tableName: String? = nil, in bundle: Bundle = Bundle.main, comment: String? = nil) -> String {
//        if let path = bundle.path(forResource: "zh-Hans", ofType: "lproj"), let localizableBundle = Bundle(path: path) {
//            return localizableBundle.localizedString(forKey: self, value: comment, table: tableName)
//        }
        return bundle.localizedString(forKey: self, value: comment, table: tableName)
    }

}