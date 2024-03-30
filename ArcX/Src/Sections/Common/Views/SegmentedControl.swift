//
// Created by LLL on 2024/3/21.
//

import Foundation

class SegmentedControl: UIControl {

    var selectedSegmentIndex: Int = -1 {
        didSet {
            if selectedSegmentIndex != oldValue {
                for i in 0..<segments.count {
                    segments[i].isSelected = i == selectedSegmentIndex
                }
                sendActions(for: .valueChanged)
            }
        }
    }

    var segments: [UIButton] = []

    init(items: [String]) {
        super.init(frame: CGRect(x: 0, y: 0, width: 345, height: 58))
        let bgView = UIImageView()
        bgView.image = UIImage(named: "img_segment_bg")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 100, bottom: 0, right: 100), resizingMode: .stretch)
        bgView.frame = bounds
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(58)
        }

        for i in 0..<items.count {
            let btn = UIButton(type: .custom)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
            btn.setTitle(items[i], for: .normal)
            btn.setTitleColor(UIColor(hex: 0xA5A5A5), for: .normal)
            btn.setTitleColor(UIColor(hex: 0xFFFFFF), for: .highlighted)
            btn.setTitleColor(UIColor(hex: 0xFFFFFF), for: .selected)
            btn.setTitleColor(UIColor(hex: 0xFFFFFF), for: [ .highlighted, .selected ])
            btn.setBackgroundImage(UIImage.pure(color: .clear, size: CGSize(width: 176, height: 56)), for: .normal)
            let bgImage = UIImage(named: "img_segment_cell_0\(i+1)")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 86, bottom: 0, right: 86), resizingMode: .stretch)
            btn.setBackgroundImage(bgImage, for: .highlighted)
            btn.setBackgroundImage(bgImage, for: .selected)
            btn.setBackgroundImage(bgImage, for: [ .highlighted, .selected ])
            btn.addTarget(self, action: #selector(segmentedButtonClick(_:)), for: .touchUpInside)
            segments.append(btn)
        }

        let stackView = UIStackView(arrangedSubviews: segments)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override var intrinsicContentSize: CGSize {
        return frame.size
    }
    // MARK: - Private

    @objc private func segmentedButtonClick(_ sender: UIButton) {
        guard let index = segments.firstIndex(where: { $0 == sender }) else { return }
        selectedSegmentIndex = index
    }


}
