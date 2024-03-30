//
// Created by LLL on 2024/3/28.
//

import UIKit

class NFTOperationView: UICollectionReusableView {

    var status: BackpackNFT.Status! {
        didSet {
            stackView.arrangedSubviews.forEach({
                stackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            })
            if status == BackpackNFT.Status.listing {
                stackView.addArrangedSubview(unListButton)
            } else {
                stackView.addArrangedSubview(listButton)
            }

            if status == BackpackNFT.Status.business {
                stackView.addArrangedSubview(stopButton)
            } else {
                stackView.addArrangedSubview(saleButton)
            }
        }
    }

    var duration: Int64 = 0 {
        didSet {

        }
    }

    var onList: (() -> Void)?
    var onUnList: (() -> Void)?
    var onSale: (() -> Void)?
    var onStop: (() -> Void)?

    private let listButton = UIButton(type: .custom)
    private let unListButton = UIButton(type: .custom)
    private let saleButton = UIButton(type: .custom)
    private let stopButton = UIButton(type: .custom)
    private let stackView = UIStackView()
    private let durationLabel = UILabel(text: nil, textColor: UIColor(hex: 0x333333), fontSize: 14, weight: .bold)
    private var timer: Timer?


    override init(frame: CGRect) {
        super.init(frame: frame)

        stackView.axis = .horizontal
        stackView.spacing = 8
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }


        listButton.titleEdgeInsets = UIEdgeInsets(top: -3, left: 8, bottom: 3, right: -8)
        listButton.setAttributedTitle(NSAttributedString(string: "LIST", attributes: [
            .foregroundColor: UIColor(hex: 0x333333),
            .font: UIFont.systemFont(ofSize: 20, weight: .bold),
            .shadow: NSShadow().then {
                $0.shadowColor = UIColor(hex: 0xF6BFEA)
                $0.shadowOffset = CGSize(width: 0, height: 2)
            }
        ]), for: .normal)
        listButton.setBackgroundImage(UIImage(named: "img_nft_listing_btn"), for: .normal)
        listButton.addTarget(self, action: #selector(listButtonClick), for: .touchUpInside)

        unListButton.titleEdgeInsets = UIEdgeInsets(top: -3, left: 18, bottom: 3, right: -18)
        unListButton.setAttributedTitle(NSAttributedString(string: "UNLIST", attributes: [
            .foregroundColor: UIColor(hex: 0x333333),
            .font: UIFont.systemFont(ofSize: 20, weight: .bold),
            .shadow: NSShadow().then {
                $0.shadowColor = UIColor(hex: 0xF6BFEA)
                $0.shadowOffset = CGSize(width: 0, height: 2)
            }
        ]), for: .normal)
        unListButton.setBackgroundImage(UIImage(named: "img_nft_listing_btn"), for: .normal)
        unListButton.addTarget(self, action: #selector(unListButtonClick), for: .touchUpInside)



        saleButton.titleEdgeInsets = UIEdgeInsets(top: -3, left: 0, bottom: 3, right: 0)
        saleButton.setAttributedTitle(NSAttributedString(string: "Sale", attributes: [
            .foregroundColor: UIColor(hex: 0x333333),
            .font: UIFont.systemFont(ofSize: 20, weight: .bold),
            .shadow: NSShadow().then {
                $0.shadowColor = UIColor(hex: 0xF6BFEA)
                $0.shadowOffset = CGSize(width: 0, height: 2)
            }
        ]), for: .normal)
        saleButton.setBackgroundImage(UIImage(named: "img_nft_sale_btn"), for: .normal)
        saleButton.addTarget(self, action: #selector(saleButtonClick), for: .touchUpInside)


        stopButton.setBackgroundImage(UIImage(named: "img_nft_stop_btn"), for: .normal)
        stopButton.addTarget(self, action: #selector(stopButtonClick), for: .touchUpInside)

        durationLabel.shadowColor = UIColor(hex: 0xFFF6E8)
        durationLabel.shadowOffset = CGSize(width: 0, height: 2)
        stopButton.addSubview(durationLabel)
        durationLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(10)
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil {
            timer?.invalidate()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
    }


    // MARK: - Public

    func startTimer(with duration: Int64) {
        timer?.invalidate()

        var seconds = duration
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] timer in
            seconds += 1
            let hour = seconds / 3600
            let minute = seconds % 3600 / 60
            let second = seconds % 60
            durationLabel.text = String(format: "OPEN %02d:%02d:%02d", hour, minute, second)
        }
        timer?.fire()
    }

    // MARK: - Private

    @objc private func listButtonClick() {
        onList?()
    }

    @objc private func unListButtonClick() {
        onUnList?()
    }

    @objc private func saleButtonClick() {
        onSale?()
    }

    @objc private func stopButtonClick() {
        onStop?()
    }


}
