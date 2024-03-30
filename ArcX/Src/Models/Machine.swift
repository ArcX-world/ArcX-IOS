//
// Created by LLL on 2024/3/13.
//

import Foundation

class Machine: Codable {
    var devId: Int                  //  设备ID
    var devNm: String               //  设备名称
    var devPct: String              //  设备图片
    var csAmt: Int                  //  游戏价格
    var plyTbln: [MachinePlayer]?    //  设备在玩玩家列表
    var devTbln: [Int]              //  设备列表
}

