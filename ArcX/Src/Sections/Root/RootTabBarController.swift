//
// Created by LLL on 2024/3/22.
//

import UIKit

class RootTabBarController: BaseViewController {

    let storeViewController = StoreViewController()
    let cardsViewController = UIViewController()
    let mainViewController = MainViewController()
    let backpackViewController = BackpackViewController()
    let rankingViewController = UIViewController()

    weak var selectedViewController: UIViewController? {
        didSet { setSelectedViewController(selectedViewController, oldSelectedViewController: oldValue) }
    }

    private var viewControllers: [UIViewController] = []

    let tabBar = RooTabBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        storeViewController.tabBarItem = UITabBarItem(title: "Store", image: UIImage(named: "img_root_tab_store"), selectedImage: UIImage(named: "img_root_tab_store_selected"))
        cardsViewController.tabBarItem = UITabBarItem(title: "Cards", image: UIImage(named: "img_root_tab_cards"), selectedImage: UIImage(named: "img_root_tab_cards_selected"))
        mainViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "img_root_tab_main"), selectedImage: UIImage(named: "img_root_tab_main_selected"))
        backpackViewController.tabBarItem = UITabBarItem(title: "NFT", image: UIImage(named: "img_root_tab_backpack"), selectedImage: UIImage(named: "img_root_tab_backpack_selected"))
        rankingViewController.tabBarItem = UITabBarItem(title: "Ranking", image: UIImage(named: "img_root_tab_ranking"), selectedImage: UIImage(named: "img_root_tab_ranking_selected"))

        viewControllers = [
            storeViewController,
            cardsViewController,
            mainViewController,
            backpackViewController,
            rankingViewController,
        ]

        tabBar.items = viewControllers.map({ $0.tabBarItem })
        tabBar.delegate = self
        view.addSubview(tabBar)
        tabBar.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
        }

        selectedViewController = mainViewController
    }



    private func setSelectedViewController(_ selectedViewController: UIViewController?, oldSelectedViewController: UIViewController?) {
        if let oldSelectedViewController = oldSelectedViewController {
            oldSelectedViewController.beginAppearanceTransition(false, animated: false)
            oldSelectedViewController.willMove(toParent: nil)
            oldSelectedViewController.view.removeFromSuperview()
            oldSelectedViewController.removeFromParent()
            oldSelectedViewController.endAppearanceTransition()
        }

        if let selectedViewController = selectedViewController {
            selectedViewController.beginAppearanceTransition(true, animated: false)
            addChild(selectedViewController)
            selectedViewController.view.frame = view.bounds
            selectedViewController.view.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
            selectedViewController.willMove(toParent: self)
            view.insertSubview(selectedViewController.view, at: 0)
            selectedViewController.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            selectedViewController.didMove(toParent: self)
            selectedViewController.endAppearanceTransition()
        }

        tabBar.selectedItem = selectedViewController?.tabBarItem
    }

}


extension RootTabBarController: RootTabBarDelegate {

    func tabBar(_ tabBar: RooTabBar, shouldSelect item: UITabBarItem) -> Bool {
        return true
    }

    func tabBar(_ tabBar: RooTabBar, didSelect item: UITabBarItem) {
        if let index = tabBar.items.firstIndex(of: item) {
            if viewControllers[index] != selectedViewController {
                selectedViewController = viewControllers[index]
            }
        }
    }
}