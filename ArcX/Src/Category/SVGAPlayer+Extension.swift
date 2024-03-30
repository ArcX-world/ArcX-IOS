//
// Created by MAC on 2023/12/6.
//

//import SVGAPlayer
//
//fileprivate struct SVGAPlayerAssociatedKeys {
//    static var currentURL: Void? = nil
//}
//extension SVGAPlayer {
//
//    private static let parser: SVGAParser = {
//        let parser = SVGAParser()
//        parser.enabledMemoryCache = true
//        return parser
//    }()
//
//    private var currentURL: URL? {
//        get { objc_getAssociatedObject(self, &SVGAPlayerAssociatedKeys.currentURL) as? URL }
//        set { objc_setAssociatedObject(self, &SVGAPlayerAssociatedKeys.currentURL, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
//    }
//
//    func setVideoItem(with videoURL: URL?, autoplay: Bool = true, completionHandler: ((Result<SVGAVideoEntity, Error>) -> Void)? = nil) {
//        currentURL = videoURL
//
//        guard let videoURL = videoURL else {
//            videoItem = nil
//            return
//        }
////        SVGADownloader.default.retrieveSVGA(with: videoURL) { result in
////            switch result {
////            case .success(let fileURL):
////                Self.parser.parse(with: fileURL, completionBlock: { videoItem in
////                    if self.currentURL?.absoluteString == videoURL.absoluteString {
////                        self.videoItem = videoItem
////                        if autoplay {
////                            self.startAnimation()
////                        }
////                        completionHandler?(.success(videoItem!))
////                    }
////                }, failureBlock: { error in
////                    completionHandler?(.failure(error!))
////                })
////                break
////            case .failure(let error):
////                completionHandler?(.failure(error))
////                break
////            }
////        }
//    }
//}
