//
// Created by LLL on 2024/3/20.
//

import Foundation

class StorePropProduct: Codable {
    var cmdId: Int              //商品ID
    var ppyAmt: Int             //道具数量
    var nm: String              //道具名称
    var dsc: String             //描述
    var pct: String             //图片
    var axcAmt: Int             //AXC价格
    var soFlg: Bool             //是否购买上限
}
