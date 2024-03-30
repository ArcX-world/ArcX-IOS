//
// Created by LLL on 2024/3/26.
//

import Moya

let nftProvider = DefaultProvider<NftAPI>()

enum NftAPI: TargetType {
    case getVendingMachine
    case exchangeToken(identifier: String, usdtAmt: Int, rate: Int)
    case getBackpackNFT(identifier: String)
    case upgradeStorage(identifier: String, amount: Int64)
    case startSales(identifier: String, price: Double)
    case stopSales(identifier: String)
    case startListing(identifier: String, price: Double)
    case stopListing(identifier: String)
    case fixDurability(identifier: String)
    case upgrade(identifier: String, attrType: Int)
    case getMarketNFTs(pageNum: Int, pageSize: Int)
    case getMarketNFT(identifier: String)
    case purchaseNFT(identifier: String)
    case getNFTReport(identifier: String, pageNum: Int, pageSize: Int)


    var baseURL: URL {
        return URL(string: Constants.App.domain)!
    }

    var path: String {
        switch self {
        case .getVendingMachine: return "/opr_sel_gd_mch"
        case .exchangeToken: return "/exc_nft_gd"
        case .getBackpackNFT: return "/nft_ifo"
        case .upgradeStorage: return "/sel_gd_mch_ad_gd"
        case .startSales: return "/sel_gd_mch_opr"
        case .stopSales: return "/sel_gd_mch_stp_opr"
        case .startListing: return "/sel_gd_mch_lst_mk"
        case .stopListing: return "/sel_gd_mch_cacl_mk"
        case .fixDurability: return "/sel_gd_mch_rp_drblt"
        case .upgrade: return "/upg_nft"
        case .getMarketNFTs: return "/mk_nft_lst"
        case .getMarketNFT: return "/mk_nft_ifo"
        case .purchaseNFT: return "/buy_nft"
        case .getNFTReport: return "/nft_rp"
        }
    }

    var method: Moya.Method {
        switch self {
        case .exchangeToken: return .post
        case .upgradeStorage: return .post
        case .startSales: return .post
        case .stopSales: return .post
        case .startListing: return .post
        case .stopListing: return .post
        case .fixDurability: return .post
        case .upgrade: return .post
        case .purchaseNFT: return .post
        default: return .get
        }
    }

    var parameters: [String: Any] {
        switch self {
        case .exchangeToken(let identifier, let usdtAmt, let rate):
            return [ "nftCd": identifier, "usdtAmt": usdtAmt, "usdtExc": rate ]
        case .getBackpackNFT(let identifier):
            return [ "nftCd": identifier ]
        case .upgradeStorage(let identifier, let amount):
            return [ "nftCd": identifier, "gdAmt": amount ]
        case .startSales(let identifier, let price):
            return [ "nftCd": identifier, "slPrc": price ]
        case .stopSales(let identifier):
            return [ "nftCd": identifier ]
        case .startListing(let identifier, let price):
            return [ "nftCd": identifier, "slPrc": price ]
        case .stopListing(let identifier):
            return [ "nftCd": identifier ]
        case .fixDurability(let identifier):
            return [ "nftCd": identifier ]
        case .upgrade(let identifier, let attrType):
            return [ "nftCd": identifier, "atbTp": attrType ]
        case .getMarketNFTs(let pageNum, let pageSize):
            return [ "pgNm": pageNum, "pgAmt": pageSize ]
        case .getMarketNFT(let identifier):
            return [ "nftCd": identifier ]
        case .purchaseNFT(let identifier):
            return [ "nftCd": identifier ]
        case .getNFTReport(let identifier, let pageNum, let pageSize):
            return [ "nftCd": identifier, "pgNm": pageNum, "pgAmt": pageSize ]
        default: return [:]
        }
    }

    var task: Task {
        var encoding: ParameterEncoding = URLEncoding.default
        if case .post = method {
            encoding = JSONEncoding.default
        }
        return .requestParameters(parameters: parameters, encoding: encoding)
    }

    var headers: [String: String]? {
        return nil
    }

}
