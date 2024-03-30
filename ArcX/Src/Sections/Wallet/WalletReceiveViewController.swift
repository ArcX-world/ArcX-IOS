//
// Created by LLL on 2024/3/23.
//

import UIKit

class WalletReceiveViewController: BaseViewController {

    var address: String = ""

    init(address: String) {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        self.address = address
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
    }


    @objc private func dismissVC() {
        presentingViewController?.dismiss(animated: true)
    }

    @objc private func copyButtonClick() {
        ToastView.showToast("Copied", in: view)
        UIPasteboard.general.string = address
    }

    private func createQRCodeImage(with string: String) -> UIImage? {
        let filter = CIFilter(name: "CIQRCodeGenerator")!
        filter.setValue(string.data(using: .utf8), forKey: "inputMessage")
        var outputImage = filter.outputImage

        let colorFilter = CIFilter(name: "CIFalseColor")!
        colorFilter.setDefaults()
        colorFilter.setValue(outputImage, forKey: "inputImage")
        colorFilter.setValue(CIColor(color: UIColor.black), forKey: "inputColor0")
        colorFilter.setValue(CIColor(color: UIColor.clear), forKey: "inputColor1")
        outputImage = colorFilter.outputImage
        outputImage = outputImage?.transformed(by: CGAffineTransformMakeScale(10, 10))

        var image: UIImage?
        if let outputImage = outputImage {
            image = UIImage(ciImage: outputImage)
        }
        UIGraphicsEndImageContext()
        return image
    }

    private func commonInit() {

        let dismissView = UIView(frame: view.bounds)
        dismissView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissVC)))
        view.addSubview(dismissView)

        let contentView = UIImageView()
        contentView.image = UIImage(named: "img_wallet_receive_bg")?.resizeImage(withWidth: view.frame.width)
        contentView.isUserInteractionEnabled = true
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
        }

        let titleLabel = UILabel(text: "Receive")
        titleLabel.font = UIFont(name: "qiantuhouheiti", size: 22)
        titleLabel.textColor = UIColor(hex: 0x66EEFF)
        titleLabel.shadowColor = UIColor(hex: 0x273C76)
        titleLabel.shadowOffset = CGSize(width: 0, height: 2)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(9)
            make.centerX.equalToSuperview()
        }

        let qrcodeWrapView = UIView()
        qrcodeWrapView.backgroundColor = .white
        qrcodeWrapView.layer.cornerRadius = 13
        qrcodeWrapView.layer.masksToBounds = true
        contentView.addSubview(qrcodeWrapView)
        qrcodeWrapView.snp.makeConstraints { make in
            make.top.equalTo(60)
            make.centerX.equalToSuperview()
            make.size.equalTo(186)
        }

        let qrcodeView = UIImageView()
        qrcodeView.image = createQRCodeImage(with: address)
        qrcodeWrapView.addSubview(qrcodeView)
        qrcodeView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        }


        let scanLabel = UILabel(text: "Scan address", textColor: UIColor(hex: 0x333333), fontSize: 16, weight: .medium)
        contentView.addSubview(scanLabel)
        scanLabel.snp.makeConstraints { make in
            make.top.equalTo(qrcodeWrapView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        let addressView = UIImageView()
        addressView.image = UIImage(named: "img_wallet_address")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50), resizingMode: .stretch)
        contentView.addSubview(addressView)
        addressView.snp.makeConstraints { make in
            make.top.equalTo(scanLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 212, height: 26))
        }

        let addressLabel = UILabel(text: address, textColor: UIColor(hex: 0xACA7B7), fontSize: 12, weight: .bold)
        addressLabel.lineBreakMode = .byTruncatingMiddle
        addressView.addSubview(addressLabel)
        addressLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }

        let copyButton = UIButton.primary(title: "COPY")
        copyButton.addTarget(self, action: #selector(copyButtonClick), for: .touchUpInside)
        contentView.addSubview(copyButton)
        copyButton.snp.makeConstraints { make in
            make.top.equalTo(addressView.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
        }

    }

}
