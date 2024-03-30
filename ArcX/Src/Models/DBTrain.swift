//
// Created by LLL on 2024/3/19.
//

import Foundation

class DBTrain: Codable {

    class Icon: Codable {
        var cmdTp: Int
        var awdInx: Int
    }

    var icTbln: [String]
    var icAwdTbln: [Icon]
    var awdTbln: [BonusItem]
}
