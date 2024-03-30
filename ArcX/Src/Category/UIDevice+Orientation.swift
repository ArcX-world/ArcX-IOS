//
// Created by MAC on 2023/11/22.
//

import UIKit

fileprivate struct UIDeviceAssociatedKeys {
    static var interfaceOrientation: Void? = nil
}

extension UIDevice {

    var interfaceOrientation: UIInterfaceOrientation {
        get {
            if let val = objc_getAssociatedObject(self, &UIDeviceAssociatedKeys.interfaceOrientation) as? Int {
                if let orientation = UIInterfaceOrientation(rawValue: val) {
                    return orientation
                }
            }
            return .unknown
        }
        set {
            objc_setAssociatedObject(self, &UIDeviceAssociatedKeys.interfaceOrientation, newValue.rawValue, .OBJC_ASSOCIATION_ASSIGN)
            if #available(iOS 16.0, *) {
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                    let mask = UIInterfaceOrientationMask(rawValue: UInt(newValue.rawValue))
                    let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: mask)
                    windowScene.requestGeometryUpdate(geometryPreferences)
                }
            } else {
                beginGeneratingDeviceOrientationNotifications()
                setValue(newValue.rawValue, forKey: "orientation")
                endGeneratingDeviceOrientationNotifications()
            }
        }
    }

}
