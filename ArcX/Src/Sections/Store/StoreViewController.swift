//
// Created by LLL on 2024/3/20.
//

import UIKit
import SwiftyJSON

class StoreViewController: BaseViewController {

    enum Banner {
        case superPlayer(item: StoreSuperPlayer)
        case vendingMachine(url: String)
    }

    enum Section {
        case banner(banners: [Banner])
        case token(products: [StoreTokenProduct])
        case prop(products: [StorePropProduct])

        var numberOfItems: Int {
            switch self {
            case .banner(let banners): return banners.count
            case .token(let products): return products.count
            case .prop(let products): return products.count
            }
        }
    }

    private var dataSource: [Section] = []

    private var collectionView: UICollectionView!
    private var refreshView: UIView!
    private var timeLabel: UILabel!
    private lazy var navigationBar = UserNavigationBar()

    private var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogin), name: .UserDidLoginNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userDidLogout), name: .UserDidLogoutNotification, object: nil)
        commonInit()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed || navigationController == nil {
            timer?.invalidate()
        }
    }



    // MARK: - Private

    private func loadData() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        storeProvider.request(.getStoreMsg) { result in
            hud.hide()
            switch result {
            case .success(let response):
                var banners: [Banner] = []
                if let item = try? response.map(StoreSuperPlayer.self, atKeyPath: "serverMsg.spPlyIfo") {
                    banners.append(.superPlayer(item: item))
                }
                if let url = try? response.map(String.self, atKeyPath: "serverMsg.selCnMch"), url.count > 0 {
                    banners.append(.vendingMachine(url: url))
                }

                let tokenProducts = (try? response.map(Array<StoreTokenProduct>.self, atKeyPath: "serverMsg.cnTbln")) ?? []
                let propProducts = (try? response.map(Array<StorePropProduct>.self, atKeyPath: "serverMsg.ppyIfo.ppyTbln")) ?? []

                self.dataSource = [
                    .banner(banners: banners),
                    .token(products: tokenProducts),
                    .prop(products: propProducts),
                ]
                self.collectionView.reloadData()

                if let leftTime = try? response.map(Int.self, atKeyPath: "serverMsg.ppyIfo.rfTm") {
                    self.startTimer(leftTime)
                }
                //rfAxcAmt
                break
            case .failure(let error):
                break
            }
        }
    }

    private func startTimer(_ seconds: Int) {
        var seconds = seconds
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            seconds -= 1

            let hour = seconds / 3600
            let minute = seconds % 3600 / 60
            let second = seconds % 60
            self.timeLabel.text = String(format: "%02d:%02d:%02d", hour, minute, second)

            if seconds <= 0 {
                timer.invalidate()
            }
        }
        timer?.fire()
    }

    @objc private func userDidLogin() {
        loadData()
    }

    @objc private func userDidLogout() {

    }


    private func commonInit() {
        title = "Store"
        view.layer.contents = UIImage.gradient(colors: [ UIColor(hex: 0x8A8DCF), UIColor(hex: 0xDDC6F6), UIColor(hex: 0xFFEDE0), UIColor(hex: 0xC6B1FF) ], size: view.frame.size, end: CGPoint(x: 0, y: 1)).cgImage

        let headerView = UIImageView()
        headerView.image = UIImage(named: "img_store_header")?.resizeImage(withWidth: view.frame.width)
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.equalToSuperview()
        }

        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 60, right: 0)
        collectionView.register(StoreBannerViewCell.self, forCellWithReuseIdentifier: "StoreBannerViewCell")
        collectionView.register(StoreTokenViewCell.self, forCellWithReuseIdentifier: "StoreTokenViewCell")
        collectionView.register(StorePropViewCell.self, forCellWithReuseIdentifier: "StorePropViewCell")
        collectionView.register(StoreSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "StoreSectionHeaderView")
        view.insertSubview(collectionView, at: 0)

        collectionView.transform = CGAffineTransform.identity
                .scaledBy(x: Dimensions.WLR, y: Dimensions.WLR)
                .translatedBy(x: 0, y: view.frame.width * (Dimensions.WLR - 1.0))
        collectionView.contentInset.bottom += view.frame.height * (Dimensions.WLR - 1.0)


        refreshView = UIView(frame: CGRect(x: 0, y: 0, width: 90, height: 36))

        let refreshButton = UIButton(image: UIImage(named: "img_store_refresh"))
        refreshView.addSubview(refreshButton)
        refreshButton.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview()
        }

        timeLabel = UILabel(text: "00:00:00", textColor: .white, fontSize: 13, weight: .semibold)
        timeLabel.sizeToFit()
        refreshView.insertSubview(timeLabel, at: 0)
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(refreshButton.snp.right).offset(-2)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.width.equalTo(timeLabel.frame.width + 2)
        }
    }

}

// MARK: - UICollectionViewDataSource
extension StoreViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].numberOfItems
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch dataSource[indexPath.section] {
        case .banner(let banners):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreBannerViewCell", for: indexPath) as! StoreBannerViewCell
            switch banners[indexPath.row] {
            case .superPlayer(let item):
                cell.configCell(item.pct)
            case .vendingMachine(let url):
                cell.configCell(url)
            }
            return cell
        case .token(let products):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StoreTokenViewCell", for: indexPath) as! StoreTokenViewCell
            cell.configCell(products[indexPath.row])
            return cell
        case .prop(let products):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StorePropViewCell", for: indexPath) as! StorePropViewCell
            let col = indexPath.row % 3
            cell.configCell(products[indexPath.row], col: col)
            return cell
        }
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "StoreSectionHeaderView", for: indexPath) as! StoreSectionHeaderView
        switch dataSource[indexPath.section] {
        case .banner:
            headerView.imageView.image = nil
        case .token:
            headerView.imageView.image = UIImage(named: "img_store_section_coins")
        case .prop:
            headerView.imageView.image = UIImage(named: "img_store_section_prop")

            headerView.addSubview(refreshView)
            refreshView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.right.equalTo(headerView.imageView).offset(-14)
            }
        }
        return headerView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension StoreViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let size: CGSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: IndexPath(row: 0, section: section))
        switch dataSource[section] {
        case .banner:
            let marginLR = floor((view.frame.width - size.width) * 0.5)
            return UIEdgeInsets(top: 16, left: marginLR, bottom: 16, right: marginLR)
        case .token, .prop:
            let spacing = self.collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAt: section)
            let marginLR = floor((view.frame.width - size.width * 3 - spacing * 2) * 0.5)
            return UIEdgeInsets(top: 16, left: marginLR, bottom: 16, right: marginLR)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch dataSource[section] {
        case .banner: return 0
        case .token, .prop: return 3
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch dataSource[section] {
        case .banner: return 16
        case .token, .prop: return 10
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch dataSource[section] {
        case .banner: return CGSize()
        case .token, .prop: return CGSize(width: collectionView.frame.width, height: 42)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize()
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch dataSource[indexPath.section] {
        case .banner:
            return CGSize(width: 343, height: 118)
        case .token, .prop:
            return CGSize(width: 117, height: 168)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch dataSource[indexPath.section] {
        case .banner(let banners):
            let banner = banners[indexPath.row]
            switch banner {
            case .superPlayer(let item):
                let payViewController = StorePaymentViewController()
                payViewController.spProduct = item
                payViewController.onDismissed = { [weak self] in
                    self?.loadData()
                }
                present(payViewController, animated: true)
                break
            case .vendingMachine:
                show(VendingMachineViewController(), sender: nil)
                break
            }
            break
        case .token(let products):
            let payViewController = StorePaymentViewController()
            payViewController.tokenProduct = products[indexPath.row]
            payViewController.onDismissed = { [weak self] in
                self?.loadData()
            }
            present(payViewController, animated: true)
            break
        case .prop(let products):
            let payViewController = StorePaymentViewController()
            payViewController.propProduct = products[indexPath.row]
            payViewController.onDismissed = { [weak self] in
                self?.loadData()
            }
            present(payViewController, animated: true)
            break
        }

    }


}