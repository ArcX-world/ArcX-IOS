//
// Created by MAC on 2024/1/2.
//

import Foundation

extension FileManager {

    func fileSize(atPath path: String) -> UInt64 {
        var totalSize: UInt64 = 0

        var isDir = ObjCBool.init(false)
        if fileExists(atPath: path, isDirectory: &isDir) {
            if !isDir.boolValue {
                if let attr = try? attributesOfItem(atPath: path), let size = attr[.size] as? UInt64 {
                    totalSize += size
                }
            } else {
                if let subpaths = subpaths(atPath: path) {
                    for subpath in subpaths {
                        let filePath = (path as NSString).appendingPathComponent(subpath)
                        if fileExists(atPath: filePath, isDirectory: &isDir) {
                            if !isDir.boolValue {
                                if let attr = try? attributesOfItem(atPath: filePath), let size = attr[.size] as? UInt64 {
                                    totalSize += size
                                }
                            }
                        }
                    }
                }

            }
        }

        return totalSize
    }
}