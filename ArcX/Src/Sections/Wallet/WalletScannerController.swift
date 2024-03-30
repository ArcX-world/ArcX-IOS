//
// Created by LLL on 2024/3/26.
//

import UIKit
import AVFoundation

class WalletScannerController: BaseViewController {

    let SOLANA_ADDRESS_LENGTH: Int = 44

    var resultBlock: ((String) -> Void)?
    private var isReading: Bool = false

    private let captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scan"
        view.backgroundColor = .black

        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.openCapture()
                } else {
                    let alertController = UIAlertController(title: "Tips", message: "Please allow the app to access your camera in the \"Settings-Privacy-Camera\" option on your iPhone", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alertController, animated: true)
                }
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if navigationController == nil {

        }
    }

    private func openCapture() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        do {
            let deviceInput = try AVCaptureDeviceInput(device: device)

            let metadataOutput = AVCaptureMetadataOutput()
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.global())

            captureSession.addInput(deviceInput)
            captureSession.addOutput(metadataOutput)

            metadataOutput.metadataObjectTypes = [ .qr ]
            metadataOutput.rectOfInterest = CGRect(x: 0.2, y: 0.2, width: 0.8, height: 0.8)
        } catch {
            logger.error(error)
        }

        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = view.bounds
        view.layer.insertSublayer(videoPreviewLayer, at: 0)

        captureSession.startRunning()
    }


}


// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension WalletScannerController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if isReading { return }

        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {

            isReading = true

            if stringValue.count == SOLANA_ADDRESS_LENGTH {
                captureSession.stopRunning()
                DispatchQueue.main.async {
                    self.resultBlock?(stringValue)
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    ToastView.showToast("Invalid SOLANA wallet address.", in: self.view)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.isReading = false
                }
            }
        }
    }

}