//
// Created by LLL on 2024/3/22.
//

import UIKit

protocol RootTabBarDelegate: NSObjectProtocol {
    func tabBar(_ tabBar: RooTabBar, shouldSelect item: UITabBarItem) -> Bool
    func tabBar(_ tabBar: RooTabBar, didSelect item: UITabBarItem)
}

class RooTabBar: UIView {

    var items: [UITabBarItem] = [] {
        didSet {
            setItems(items)
        }
    }

    weak var selectedItem: UITabBarItem? {
        didSet {
            if selectedItem != oldValue {
                setSelectedItem(selectedItem)
            }
        }
    }

    weak var delegate: RootTabBarDelegate?

    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
    }


    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 375, height: 86))

        let bgView = UIImageView(image: UIImage(named: "img_root_tab_bg"))
        addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override var intrinsicContentSize: CGSize {
        return frame.size
    }

    // MARK: - Private Methods

    private func setItems(_ items: [UITabBarItem]) {
        stackView.arrangedSubviews.forEach {
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        stackView.subviews.forEach({ $0.removeFromSuperview() })

        let itemButtons = items.map({ RootTabBarButton($0) })
        for button in itemButtons {
            button.addTarget(self, action: #selector(tabItemClick(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }

    }

    private func setSelectedItem(_ selectedItem: UITabBarItem?) {
        let buttons = stackView.arrangedSubviews as! [RootTabBarButton]
        for btn in buttons {
            btn.isSelected = btn.tabBarItem == selectedItem
        }
        if let selectedItem = selectedItem {
            delegate?.tabBar(self, didSelect: selectedItem)
        }
    }

    // MARK: - Events

    @objc
    private func tabItemClick(_ sender: RootTabBarButton) {
        if selectedItem != sender.tabBarItem {
            let shouldSelect = delegate?.tabBar(self, shouldSelect: sender.tabBarItem) ?? true
            if shouldSelect {
                selectedItem = sender.tabBarItem
            }
        }
    }

}

private class RootTabBarButton: UIButton {

    var tabBarItem: UITabBarItem!

    init(_ tabBarItem: UITabBarItem) {
        super.init(frame: CGRect(x: 0, y: 0, width: 125, height: 88))
        self.tabBarItem = tabBarItem
        setImage(tabBarItem.image, for: .normal)
        setImage(tabBarItem.image, for: .highlighted)
        setImage(tabBarItem.selectedImage, for: .selected)
        setImage(tabBarItem.selectedImage, for: [ .selected, .highlighted ])

        setAttributedTitle(NSAttributedString(string: ""), for: .normal)
        setAttributedTitle(NSAttributedString(string: ""), for: .highlighted)

        let highlightedTitle = NSAttributedString(string: "\(tabBarItem.title!)", attributes: [
            .foregroundColor: UIColor(hex: 0x66EEFF),
            .font: UIFont(name: "qiantuhouheiti", size: 16),
            .shadow: NSShadow().then {
                $0.shadowColor = UIColor(hex: 0x273C76)
                $0.shadowOffset = CGSize(width: 0, height: 2)
            }
        ])
        setAttributedTitle(highlightedTitle, for: .selected)
        setAttributedTitle(highlightedTitle, for: [ .selected, .highlighted ])

        setBackgroundImage(UIImage.pure(color: .clear, size: UIImage(named: "img_root_tab_item_selected")!.size), for: .normal)
        setBackgroundImage(UIImage(named: "img_root_tab_item_selected"), for: .highlighted)
        setBackgroundImage(UIImage(named: "img_root_tab_item_selected"), for: .selected)
        setBackgroundImage(UIImage(named: "img_root_tab_item_selected"), for: [ .selected, .highlighted ])
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.8
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageSize = imageView?.image?.size, let titleSize = titleLabel?.attributedText?.size() else { return }
        if isSelected {
            let titleOffset = imageSize.height * 0.6
            titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -titleOffset, right: 0)
            let imageOffset = titleSize.height * 0.5
            imageEdgeInsets = UIEdgeInsets(top: -imageOffset, left: 0, bottom: 0, right: -titleSize.width)
        } else {
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }

    }
}
