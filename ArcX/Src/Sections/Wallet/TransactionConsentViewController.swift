//
// Created by LLL on 2024/3/23.
//

import UIKit
import WebKit

class TransactionConsentViewController: BaseViewController {

    private var url: String = ""

    private var webView: WKWebView!
    private var loadingHUD: ProgressHUD?

    init(url: String) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transaction"

        let configuration = WKWebViewConfiguration()

        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.navigationDelegate = self
        view.addSubview(webView)

        webView.load(URLRequest(url: URL(string: url)!))
        loadingHUD = ProgressHUD.showHUD(addedTo: view)
    }

}

// MARK: - WKNavigationDelegate
extension TransactionConsentViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loadingHUD?.hide()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loadingHUD?.hide()
    }
}
