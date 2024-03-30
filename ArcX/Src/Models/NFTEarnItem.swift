//
// Created by LLL on 2024/3/29.
//

import Foundation

class NFTEarnItem: Codable {
    var opTm: TimeInterval      // 出售时间
    var opTlTm: Int             // 营业时长
    var opPrc: Int64            // 出售价格
    var inc: Double             // 实际收入
    var tax: Double             // 费率
    var blAmt: Int64            // 剩余金币数
}
