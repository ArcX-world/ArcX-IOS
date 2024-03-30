//
// Created by LLL on 2024/3/28.
//

import UIKit

class NFTSegmentedControl: UIControl {

    var selectedSegmentIndex: Int = -1 {
        didSet {
            if selectedSegmentIndex != oldValue {
                for i in 0..<segments.count {
                    segments[i].isSelected = i == selectedSegmentIndex
                }
                sendActions(for: .valueChanged)
                bgView.image = UIImage(named: "img_nft_segment_tab0\(selectedSegmentIndex+1)")
                setNeedsLayout()
            }
        }
    }

    var segments: [UIButton] = []

    private let bgView = UIImageView()

    init(items: [String]) {
        super.init(frame: CGRect(x: 0, y: 0, width: 375, height: 56))

        for i in 0..<items.count {
            let btn = UIButton(type: .custom)
            btn.titleEdgeInsets = UIEdgeInsets(top: -4, left: 0, bottom: 4, right: 0)

            let title = NSAttributedString(string: items[i], attributes: [
                .foregroundColor: UIColor(hex: 0x6A6B7C),
                .font: UIFont.systemFont(ofSize: 16, weight: .bold),
            ])
            btn.setAttributedTitle(title, for: .normal)

            let selectedTitle = NSAttributedString(string: items[i], attributes: [
                .foregroundColor: UIColor(hex: 0xFFFFFF),
                .font: UIFont.systemFont(ofSize: 20, weight: .bold),
                .shadow: NSShadow().then {
                    $0.shadowColor = UIColor(hex: 0xBA9620)
                    $0.shadowOffset = CGSize(width: 0, height: 2)
                }
            ])
            btn.setAttributedTitle(selectedTitle, for: .selected)
            btn.setAttributedTitle(selectedTitle, for: .highlighted)
            btn.setAttributedTitle(selectedTitle, for: [ .selected, .highlighted ])

//            let bgImage = UIImage(named: "img_nft_segmented_tab0\(i)")
//            btn.setBackgroundImage(bgImage, for: .highlighted)
//            btn.setBackgroundImage(bgImage, for: .selected)
//            btn.setBackgroundImage(bgImage, for: [ .highlighted, .selected ])
            btn.addTarget(self, action: #selector(segmentedButtonClick(_:)), for: .touchUpInside)
            segments.append(btn)
        }

        let stackView = UIStackView(arrangedSubviews: segments)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(56)
        }

        insertSubview(bgView, at: 0)

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let image = bgView.image {
            bgView.frame = CGRect(x: 0, y: 0, width: frame.width, height: image.size.width / frame.width * image.size.height)
        }
    }

    // MARK: - Private

    @objc private func segmentedButtonClick(_ sender: UIButton) {
        guard let index = segments.firstIndex(where: { $0 == sender }) else { return }
        selectedSegmentIndex = index
    }

}
