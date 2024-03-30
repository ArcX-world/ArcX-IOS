//
// Created by LLL on 2024/3/14.
//

import UIKit
import SwiftyJSON

class MachineViewController: BaseViewController {

    var machineDetails: MachineDetails!

    var machineBasedViewController: MachineBasedViewController!

    private lazy var playView = SmartPlayView(frame: UIScreen.main.bounds).then {
        $0.delegate = self
    }

    private weak var loadingHUD: ProgressHUD?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .fullScreen
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isIdleTimerDisabled = true
        WebSocket.client.add(delegate: self)
        commonInit()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logger.info("")
        if playView.url != machineDetails.lvAds {
            playView.stop()
            playView.play(machineDetails.lvAds)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed || navigationController == nil {
            UIApplication.shared.isIdleTimerDisabled = false
            WebSocket.client.remove(delegate: self)
            playView.stop()

            if let machineBasedViewController = machineBasedViewController, machineBasedViewController.parent != nil {
                machineBasedViewController.beginAppearanceTransition(false, animated: false)
                machineBasedViewController.willMove(toParent: nil)
                machineBasedViewController.view.removeFromSuperview()
                machineBasedViewController.removeFromParent()
                machineBasedViewController.endAppearanceTransition()
            }
        }
    }


    // MARK: - Public

    func present(with machineId: Int, in viewController: UIViewController) {
        loadingHUD = ProgressHUD.showHUD(addedTo: viewController.view.window ?? viewController.view)

        let getCurrentMachineBlock: (@escaping (Int) -> Void) -> Void  = { completion in
            machineProvider.request(.getCurrentMachine) { result in
                switch result {
                case .success(let response):
                    do {
                        let currentId = try response.map(Int.self, atKeyPath: "serverMsg.devId")
                        if currentId > 0 {
                            completion(currentId)
                        } else {
                            completion(machineId)
                        }
                    } catch {}
                    break
                case .failure:
                    completion(machineId)
                    break
                }
            }
        }

        let getMachineBlock: (Int, @escaping (Result<MachineDetails, Error>) -> Void) -> Void = { machineId, completion in
            machineProvider.request(.getMachine(id: machineId)) { result in
                switch result {
                case .success(let response):
                    do {
                        let machineDetails = try response.map(MachineDetails.self, atKeyPath: "serverMsg")
                        completion(.success(machineDetails))
                    } catch {
                        logger.error(error)
                        completion(.failure(error))
                    }
                    break
                case .failure(let error):
                    completion(.failure(error))
                    break
                }
            }
        }


        getCurrentMachineBlock { machineId in
            getMachineBlock(machineId) { result in
                self.loadingHUD?.hide()
                switch result {
                case .success(let machineDetails):
                    self.machineDetails = machineDetails
                    self.machineBasedViewController = self.machineBasedViewController(forCategory: machineDetails.devTp, type: machineDetails.sndTp)
                    viewController.present(self, animated: true)
                    break
                case .failure(let error):
                    ToastView.showToast(error.localizedDescription, in: viewController.view)
                    break
                }
            }
        }
    }



    // MARK: - Private

    private func machineBasedViewController(forCategory category: Int, type: Int) -> MachineBasedViewController {
        switch category {
        case MachineCategory.pusher.rawValue:
            switch type {
            case MachineType.kk.rawValue:
                return KingKongViewController()
            case MachineType.egyptian.rawValue:
                return EgyptianViewController()
            case MachineType.magicEast.rawValue:
                return MagicEastViewController()
            case MachineType.thunder.rawValue:
                return ThunderViewController()
            case MachineType.jokerCircus.rawValue:
                return JokerCircusViewController()
            case MachineType.pirateWorld.rawValue:
                return PirateWorldViewController()
            default:
                return PusherMachineViewController()
            }
        case MachineCategory.claw.rawValue:
            return ClawMachineViewController()
        case MachineCategory.gift.rawValue:
            return BallMachineViewController()
        default:
            return MachineBasedViewController()
        }
    }

    private func commonInit() {
        view.backgroundColor = .black

        playView.setMute(true)
        view.addSubview(playView)
        playView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        if let loadingHUD = loadingHUD {
            loadingHUD.loadingView.style = .white
            loadingHUD.isUserInteractionEnabled = false
            view.addSubview(loadingHUD)
            loadingHUD.snp.remakeConstraints { make in
                make.edges.equalToSuperview()
            }
        }

        machineBasedViewController.machineDetails = machineDetails
        machineBasedViewController.playView = playView

        machineBasedViewController.beginAppearanceTransition(true, animated: false)
        addChild(machineBasedViewController)
        machineBasedViewController.view.frame = view.bounds
        machineBasedViewController.view.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        machineBasedViewController.willMove(toParent: self)
        view.insertSubview(machineBasedViewController.view, aboveSubview: playView)
        machineBasedViewController.didMove(toParent: self)
        machineBasedViewController.endAppearanceTransition()
    }

}


// MARK: - WebSocketDelegate
extension MachineViewController: WebSocketDelegate {

    func webSocket(_ webSocket: WebSocket, didConnectToURL url: URL) {

    }

    func webSocketDidDisconnect(_ webSocket: WebSocket, with error: Error?) {
    }

    func webSocket(_ webSocket: WebSocket, didReceiveText text: String) {
        let json = JSON(parseJSON: text)
        if let devId = json["param"]["serverMsg"]["devId"].int, devId != machineDetails.devId {
            //
        } else {
            machineBasedViewController?.webSocket(webSocket, didReceiveJson: json)
        }
    }
}

// MARK: - SmartPlayViewDelegate
extension MachineViewController: SmartPlayViewDelegate {

    open func playView(_ playView: SmartPlayView!, didReceiveResolutionInfo size: CGSize) {
        logger.info(" \(size)")
        if let loadingHUD = loadingHUD {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { loadingHUD.hide() }
        }
    }
}