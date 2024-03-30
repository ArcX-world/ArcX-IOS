//
// Created by MAC on 2023/12/12.
//

import Foundation

class RefreshFooter: RefreshComponent {

    init(target: Any, action: Selector?) {
        super.init(frame: CGRect(x: 0, y: 0, width: 375, height: 44))
        setRefreshingTarget(target, action: action)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }


    // MARK: -

    func endRefreshingWithNoMore() {
        state = .noMore
    }

    func noticeNoMore() {
        endRefreshingWithNoMore()
    }

    func resetNoMore() {
        state = .idle
    }

}
