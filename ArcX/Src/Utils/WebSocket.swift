//
// Created by MAC on 2023/11/17.
//

import Foundation
import Starscream

protocol WebSocketDelegate: NSObjectProtocol {
    func webSocket(_ webSocket: WebSocket, didConnectToURL url: URL)
    func webSocketDidDisconnect(_ webSocket: WebSocket, with error: Error?)
    func webSocket(_ webSocket: WebSocket, didReceiveText text: String)
}

class WebSocket: NSObject, Starscream.WebSocketDelegate {

    enum State {
        case connecting
        case connected
        case disconnected
    }


    static let client = WebSocket()

    var state: State = .disconnected

    var timeoutInterval: TimeInterval = 7.0

    private var webSocket: Starscream.WebSocket!
    private var isKeepLive: Bool = true
    private var delegates: [Int: WebSocketDelegate] = [:]


    // MARK: - Public

    func connect(url: URL) {
        logger.info("[WS] connect: \(url.absoluteString)")
        if webSocket != nil {
            webSocket.delegate = nil
            webSocket.disconnect()
        }
        state = .connecting
        isKeepLive = true
        let request =  URLRequest(url: url, timeoutInterval: timeoutInterval)
        webSocket = Starscream.WebSocket(request: request, useCustomEngine: false)
        webSocket.delegate = self
        webSocket.connect()
    }

    func disconnect() {
        isKeepLive = false
        webSocket.disconnect()
    }

    @objc func reconnect() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reconnect), object: nil)
        if let url = webSocket?.request.url {
            logger.info("[WS] reconnect ...")
            webSocket.disconnect()
            connect(url: url)
            perform(#selector(reconnect), with: nil, afterDelay: 5.0)
        }
    }

    func add(delegate: WebSocketDelegate) {
        delegates[delegate.hash] = delegate
    }

    func remove(delegate: WebSocketDelegate) {
        delegates.removeValue(forKey: delegate.hash)
    }

    func send(string: CustomStringConvertible) {
        let str = string.description
        logger.info("[WS] >>> \(str)", functionName: "")
        webSocket?.write(string: str)
    }


    // MARK: - WebSocketDelegate

    func didReceive(event: WebSocketEvent, client: WebSocketClient) {
        switch event {
        case .connected:
            logger.info("[WS] connected")
            state = .connected
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reconnect), object: nil)
            delegates.values.forEach({ $0.webSocket(self, didConnectToURL: webSocket.request.url!) })
            break
        case .text(let text):
            logger.info("[WS] <<< \(text)", functionName: "")
            delegates.values.forEach { $0.webSocket(self, didReceiveText: text) }
            break
        case .disconnected:
            logger.info("[WS] disconnected")
            state = .disconnected
            delegates.values.forEach({ $0.webSocketDidDisconnect(self, with: nil) })
            break
        case .cancelled:
            logger.info("[WS] cancelled")
            state = .disconnected
            delegates.values.forEach({ $0.webSocketDidDisconnect(self, with: nil) })
            break
        case .error(let error):
            logger.info("[WS] error: \(error)")
            state = .disconnected
            delegates.values.forEach({ $0.webSocketDidDisconnect(self, with: error) })
            if isKeepLive {
                perform(#selector(reconnect), with: nil, afterDelay: 3.0)
            }
            break
        case .reconnectSuggested(let suggest):
            logger.info("[WS] reconnectSuggested suggest:\(suggest)")
            if suggest {
                reconnect()
            }
            break
        case .viabilityChanged(let isValid):
            logger.info("[WS] viabilityChanged, isValid:\(isValid)")
            if !isValid {
                reconnect()
            }
            break
        default:
            break
        }
    }

}

