//
// Created by LLL on 2024/3/27.
//

import Foundation

class BackpackNFT: Codable {
    var nftCd: String               // NFT编号
    var nftTp: Int                  // NFT类型    /1售币机/2推币机/3娃娃机/4礼品机
    var nm: String                  // 名称
    var pct: String                 // 图片
    var stat: Int                   // 状态       /1闲置/2上架状态/3广告中/4营业中
    var atbTbln: [Attribute]?       // 属性列表
}

extension BackpackNFT {

    class Attribute: Codable {
        var atbIfo: Double          // 属性值
        var atbTp: Int              // NFT属性类型 /1等级/2储币空间/3进货折扣
    }

    enum Category: Int {
        case vendingMachine = 1
        case pusherMachine = 2
        case clawMachine = 3
        case ballMachine = 4
    }

    enum Status: Int {
        case idle = 1
        case listing = 2
        case advertising = 3
        case business = 4
    }

}


enum NFTAttributeType: Int {
    case level = 1
    case storage = 2
    case discount = 3
}