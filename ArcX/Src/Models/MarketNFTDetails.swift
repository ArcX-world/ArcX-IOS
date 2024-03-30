//
// Created by LLL on 2024/3/29.
//

import Foundation

class MarketNFTDetails: Codable {
    var nftCd: String                   // NFT编号
    var nm: String                      // 名称
    var pct: String                     // 图片
    var nftTp: Int                      // NFT类型
    var slCmdTp: Int                    // 出售商品类型
    var slAmt: Double                   // 出售价格
    var atbTbln: [Attribute]?           // 属性列表
}

extension MarketNFTDetails {

    class Attribute: Codable {
        var atbTp: Int                  // 属性类型
        var lv: Int                     // 等级
        var atbMsg: String              // 属性信息
    }
}
