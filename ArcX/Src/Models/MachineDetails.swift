//
// Created by LLL on 2024/3/14.
//

import Foundation

class MachineDetails: Codable {
    var devId: Int                  //  设备ID
    var devNm: String               //  设备名称
    var devPct: String              //  图标路径
    var lvAds: String               //  播流地址
    var devTp: Int                  //  设备类型
    var sndTp: Int                  //  设备二级分类
    var devIdx: Int                 //  设备位置
    var cmdTp: Int                  //  消耗商品类型
    var csAmt: Int                  //  消耗数量
    var devSts: Int                 //  设备占用状态
    var devDtPct: String            //  玩法说明
    var gmPly: MachinePlayer?       //  玩家信息
    var ptyMul: MachineOdds?
}

class MachineOdds: Codable {
    var mulTbln: [MachineOddsItem]
}

class MachineOddsItem: Codable {
    var mulAmt: Int
    var lmFlg: Bool
}
