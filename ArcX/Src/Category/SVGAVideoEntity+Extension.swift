//
// Created by MAC on 2023/11/28.
//

import SVGAPlayer

extension SVGAVideoEntity {

    var duration: TimeInterval {
        return TimeInterval(frames) / TimeInterval(fps)
    }
}
