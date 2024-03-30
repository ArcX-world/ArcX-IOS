//
// Created by LLL on 2024/3/14.
//

import UIKit
import SwiftyJSON
import Alamofire

class RootViewController: UINavigationController {

    private lazy var rootTabBarController = RootTabBarController(nibName: nil, bundle: nil)

    private var launchViewController: LaunchViewController?

    private var heartbeatTimer: Timer?
    private var heartbeatCount: Int = 0


    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        isNavigationBarHidden = true
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.isEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogin), name: .UserDidLoginNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userinfoDidChange), name: .UserinfoDidChangeNotification, object: nil)
        WebSocket.client.add(delegate: self)
        NetworkReachabilityManager.default?.startListening(onQueue: .main) { [weak self] status in self?.networkReachabilityStatusDidChange(status) }
        commonInit()

        launchViewController = LaunchViewController()
        launchViewController?.fadeIn(toParent: self)


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Private

    private func networkReachabilityStatusDidChange(_ reachabilityStatus: NetworkReachabilityManager.NetworkReachabilityStatus) {
        if case .reachable = reachabilityStatus {
            if let launchViewController = launchViewController {
                loadProxyMsg {
                    self.refreshToken {
                        Profile.loadCurrentProfile { _ in }
                        self.setViewControllers([ self.rootTabBarController ], animated: false)
                        self.launchViewController?.fadeOut {  }
                        self.launchViewController = nil
                    }
                }
            }
        }
    }

    private func loadProxyMsg(completion: @escaping () -> Void) {
        basicProvider.request(.getProxyMsg) { result in
            switch result {
            case .success(let response):
                do {
                    let wsArray = try response.map(Array<Dictionary<String, String>>.self, atKeyPath: "serverMsg.wsTbln")
                    if let ws = wsArray.first {
                        if let url = URL(string: "ws://\(ws["ip"]!):\(ws["port"]!)/websocket") {
                            WebSocket.client.connect(url: url)
                        }
                    }
                } catch {}
                break
            case .failure(let error):
                break
            }
            completion()
        }
    }

    private func refreshToken(completion: @escaping () -> Void) {
        if let token = AccessToken.current {
            token.refreshAccessToken { result in
                completion()
            }
        } else {
            completion()
        }
    }

    @objc private func userDidLogin() {

    }

    @objc private func userinfoDidChange() {

    }


    private func commonInit() {


    }

}



// MARK: - WebSocketDelegate
extension RootViewController: WebSocketDelegate {

    func webSocket(_ webSocket: WebSocket, didConnectToURL url: URL) {
        startHeartbeat()
    }

    func webSocketDidDisconnect(_ webSocket: WebSocket, with error: Error?) {
        stopHeartbeat()
    }

    func webSocket(_ webSocket: WebSocket, didReceiveText text: String) {
        let json = JSON(parseJSON: text)
        let cmd = json["cmd"].intValue
        let data = json["param"]["serverMsg"]
        if cmd == SocketCMD.S2C.HEARTBEAT {
            heartbeatCount -= 1
        }

    }

    private func startHeartbeat() {
        heartbeatCount = 0
        heartbeatTimer?.invalidate()
        heartbeatTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
            self.heartbeatCount += 1
            if self.heartbeatCount < 3 {
                WebSocket.client.send(string: SocketPacket(cmd: SocketCMD.C2S.HEARTBEAT, parameter: [ "n": self.heartbeatCount ]))
            } else {
                timer.invalidate()
                WebSocket.client.reconnect()
            }
        }
        heartbeatTimer?.fire()
    }

    private func stopHeartbeat() {
        heartbeatCount = 0
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
    }
}



// MARK: - UINavigationControllerDelegate
extension RootViewController: UINavigationControllerDelegate {

    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

    }
}
// MARK: - UIGestureRecognizerDelegate
extension RootViewController: UIGestureRecognizerDelegate {

}