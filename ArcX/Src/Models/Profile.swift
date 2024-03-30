//
// Created by LLL on 2024/3/13.
//

import Foundation

class Profile: Codable {
    var plyNm: String       //  昵称
    var plyPct: String      //  头像
    var email: String       //  邮箱
    var sex: Int            //  性别 1男2女
    //var plyLvIfo: UserLevel //  用户等级
    //var engIfo: UserEnergy  //  用户能量
    var atbTbln: [UserAttribute]  //  用户属性
}

class UserLevel: Codable {
    var cnAmt: Int          //  当前进度
    var ttAmt: Int          //  总进度
}

class UserEnergy: Codable {
    var cnAmt: Int          //  当前进度
    var ttAmt: Int          //  总进度
    var lfTm: Int           //  刷新时间
}

class UserAttribute: Codable {
    var atbTp: Int          //  属性类型 1经验 2能量 3充能 4空投 5幸运 6魅力
    var lv: Int             //  等级
    var nxLv: Int           //  下一等级
    var upFlg: Bool         //  是否可升级
    var cmdTp: Int          //  下一等级消耗的商品类型
    var csAmt: Int          //  消耗的商品数量
    var lvAmt: String       //  当前等级数量
    var nxLvAmt: String     //  下一等级数量
    var sdNma: Int          //  当前进度分子
    var sdDma: Int          //  当前进度分母
}

extension Profile {

    static var current: Profile?

    class func loadCurrentProfile(completion: @escaping (Result<Profile, Error>) -> Void) {
        guard AccessToken.isActive else { return }
        userProvider.request(.userinfo) { result in
            switch result {
            case .success(let response):
                do {
                    let profile = try response.map(Profile.self, atKeyPath: "serverMsg")
                    Profile.current = profile
                    completion(.success(profile))
                    NotificationCenter.default.post(name: .UserinfoDidChangeNotification, object: nil)
                } catch {
                    print("\(#function)  -> \(error)")
                }
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }

}
