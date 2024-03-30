//
// Created by LLL on 2024/3/27.
//

import Foundation

class BackpackNFTDetails: Codable {
    var nftCd: String               // NFT编号
    var nm: String                  // 名称
    var pct: String                 // 图片
    var nftTp: Int                  // NFT类型
    var adAmt: Int                  // 广告数
    var slCmdTp: Int                // 交易商品类型 /2、AXC/7、USDT
    var slTax: Double               // 交易费(%)
    var stat: Int                   // 状态
    var opTm: Int64?                // 已经营业的时间	单位（秒）
    var gdIfo: Storage?             // 储币值
    var durbtyIfo: Durability?      // 耐久度
    var atbTbln: [Attribute]?       // 属性
}

extension BackpackNFTDetails {

    class Storage: Codable {
        var cnGdAmt: Int64          // 当前储币值
        var upGdAmt: Int64          // 可添加的储币值
        var dscot: Double           // 折扣(%) discount数字
        var oriAmt: Double          // 未打折前的金币数量 1USDT=多少金币，通过这个数字，去计算价格，再减去折扣，等于实际支付价格，USDT保留4位小数
        var tax: Int                // 营业税(%)
    }

    class Durability: Codable {
        var durbtyAmt: Int64        // 耐久度
        var csAmt: Int64            // 商品数量 修复需要消耗的商品数量
        var cmdTp: Int              // 商品类型
    }

    class Attribute: Codable {
        var atbTp: Int              // NFT属性类型
        var lv: Int                 // 等级
        var nxLv: Int               // 下一等级 0则当前等级为满级
        var upFlg: Bool             // 是否可升级
        var cmdTp: Int              // 商品类型
        var csAmt: Int              // 商品数量
        var sdNma: Int              // 当前进度分子
        var sdDma: Int              // 当前进度分母
        var lvAmt: Double           // 当前等级数量
        var nxLvAmt: Double         // 下一等级数量
    }

}