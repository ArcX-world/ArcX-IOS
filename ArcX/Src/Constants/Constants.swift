//
// Created by MAC on 2023/11/15.
//

struct Constants {

    struct App {
        #if PROD
        static let domain = "https://test5.wonder.net.cn/arcx_http"
        #else
        static let domain = "https://test5.wonder.net.cn/arcx_http"
        #endif

        static let scheme = "shenzhoujieji"
        static let universalLink = "https://appszjj.shenzhoujieji.net.cn/app/"
    }

    struct WeChat {
        static let appID = "wx6e35864ce9929790"
    }

}
