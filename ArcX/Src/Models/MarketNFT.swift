//
// Created by LLL on 2024/3/29.
//

import Foundation

class MarketNFT: Codable {
    var nftCd: String               // NFT编号
    var nftTp: Int                  // NFT类型    /1售币机/2推币机/3娃娃机/4礼品机
    var nm: String                  // 名称
    var pct: String                 // 图片
    var slCmdTp: Int                // 出售商品类型
    var slAmt: Double               // 出售价格
    var atbTbln: [BackpackNFT.Attribute]?       // 属性列表
}
