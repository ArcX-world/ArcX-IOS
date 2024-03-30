//
// Created by LLL on 2024/3/27.
//

import UIKit

class BackpackNFTDetailsViewController: BaseViewController {

    private var _dataSource: [Any] = []
    private var dataSource: [Any] {
        if _dataSource.isEmpty {
            nft.atbTbln?.forEach({ _dataSource.append($0) })
            if let item = nft.gdIfo {
                _dataSource.append(item)
            }
            if let item = nft.durbtyIfo {
                _dataSource.append(item)
            }
            if let item = nft.durbtyIfo {
                _dataSource.append(1000)
            }
        }
        return _dataSource
    }

    private let navigationBar = UserNavigationBar()
    private var collectionView: UICollectionView!

    var nft: BackpackNFTDetails! {
        didSet { _dataSource.removeAll() }
    }

    init(nft: BackpackNFTDetails) {
        super.init(nibName: nil, bundle: nil)
        self.nft = nft
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .BackpackNFTDidChangeNotification, object: nil)
        commonInit()

    }



    // MARK: - Private

    @objc private func reloadData() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        nftProvider.request(.getBackpackNFT(identifier: nft.nftCd)) { result in
            hud.hide()
            switch result {
            case .success(let response):
                do {
                    self.nft = try response.map(BackpackNFTDetails.self, atKeyPath: "serverMsg")
                    self.collectionView.reloadData()
                } catch {
                    logger.error(error)
                }
                break
            case .failure(let error):
                break
            }
        }
    }

    private func stopSales() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        nftProvider.request(.stopSales(identifier: nft.nftCd)) { result in
            hud.hide()
            switch result {
            case .success:
                self.reloadData()
                break
            case .failure(let error):
                ToastView.showToast(error.localizedDescription, in: self.view)
                break
            }
        }
    }

    private func stopListing() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        nftProvider.request(.stopListing(identifier: nft.nftCd)) { result in
            hud.hide()
            switch result {
            case .success:
                self.reloadData()
                break
            case .failure(let error):
                ToastView.showToast(error.localizedDescription, in: self.view)
                break
            }
        }
    }

    @objc private func reportButtonClick() {
        show(NFTReportViewController(nft: nft), sender: nil)
    }



    private func commonInit() {
        title = "NFT"
        view.backgroundColor = UIColor(hex: 0xDAD7EB)

//        view.addSubview(navigationBar)
//        navigationBar.snp.makeConstraints { make in
//            make.top.equalTo(view.snp.topMargin)
//            make.left.right.equalToSuperview()
//        }

        let topView = UIImageView()
        //topView.image = UIImage.gradient(colors: [ UIColor(hex: 0x6973E1), UIColor(hex: 0x886AF0) ], size: CGSize(width: view.frame.width, height: 292), end: CGPoint(x: 0, y: 1))
        topView.backgroundColor = .black
        view.insertSubview(topView, at: 0)
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(292)
        }

        let nftView = UIImageView()
        nftView.kf.setImage(with: URL(string: nft.pct))
        nftView.contentMode = .scaleAspectFit
        nftView.clipsToBounds = true
        topView.addSubview(nftView)
        nftView.snp.makeConstraints { make in
//            make.top.equalTo(topView.snp.topMargin).offset(60)
//            make.centerX.equalToSuperview()
//            make.bottom.equalTo(-16)
//            make.size.equalTo(CGSize(width: 232, height: 170))
            make.edges.equalToSuperview()
        }


        let reportButton = UIButton(image: UIImage(named: "img_nft_report_btn"))
        reportButton.addTarget(self, action: #selector(reportButtonClick), for: .touchUpInside)
        view.addSubview(reportButton)
        reportButton.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin).offset(2)
            make.right.equalTo(-10)
        }


        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = floor((view.frame.width - 114 * 3 - 16 * 2) / 2)
        flowLayout.footerReferenceSize = CGSize(width: view.frame.width, height: 64)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        collectionView.register(NFTAttributeViewCell.self, forCellWithReuseIdentifier: "NFTAttributeViewCell")
        collectionView.register(NFTPropertyViewCell.self, forCellWithReuseIdentifier: "NFTPropertyViewCell")
        collectionView.register(NFTOperationView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "NFTOperationView")
        view.insertSubview(collectionView, at: 0)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }

    }


}


// MARK: - UICollectionViewDataSource
extension BackpackNFTDetailsViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = dataSource[indexPath.row]

        if item is BackpackNFTDetails.Storage {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NFTPropertyViewCell", for: indexPath) as! NFTPropertyViewCell
            cell.configCell(item as! BackpackNFTDetails.Storage)
            cell.onOp = { [weak self] in
                guard let self = self else { return }
                self.show(NFTStorageViewController(nft: self.nft), sender: nil)
            }
            return cell
        }

        if item is BackpackNFTDetails.Durability {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NFTPropertyViewCell", for: indexPath) as! NFTPropertyViewCell
            cell.configCell(item as! BackpackNFTDetails.Durability)
            cell.onOp = { [weak self] in
                guard let self = self else { return }
                self.present(NFTDurabilityViewController(nft: self.nft), animated: true)
            }
            return cell
        }
        if item is Int {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NFTPropertyViewCell", for: indexPath) as! NFTPropertyViewCell
            cell.configCell(item as! Int)
            cell.onOp = { [weak self] in
                guard let self = self else { return }
                //self.show(NFTStorageViewController(machine: self.machine), sender: nil)
            }
            return cell
        }

        let attribute = item as! BackpackNFTDetails.Attribute
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NFTAttributeViewCell", for: indexPath) as! NFTAttributeViewCell
        cell.configCell(attribute)
        cell.onUpgrade = { [weak self] in
            guard let self = self else { return }
            self.present(NFTAttributeViewController(nft: self.nft, attr: attribute), animated: true)
        }
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NFTOperationView", for: indexPath) as! NFTOperationView
        footerView.status = BackpackNFT.Status(rawValue: nft.stat)
        if footerView.status == .business {
            footerView.startTimer(with: nft.opTm ?? 0)
        }
        footerView.onList = { [weak self] in
            guard let self = self else { return }
            self.show(NFTListingViewController(nft: self.nft), sender: nil)
        }
        footerView.onUnList = { [weak self] in
            guard let self = self else { return }
            self.stopListing()
        }
        footerView.onSale = { [weak self] in
            guard let self = self else { return }
            self.show(NFTSalesViewController(nft: self.nft), sender: nil)
        }
        footerView.onStop = { [weak self] in
            guard let self = self else { return }
            self.stopSales()
        }
        return footerView
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension BackpackNFTDetailsViewController: UICollectionViewDelegateFlowLayout {

//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        fatalError("collectionView(_:layout:insetForSectionAt:) has not been implemented")
//    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = dataSource[indexPath.row]
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        if item is BackpackNFTDetails.Attribute {
            let width = view.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
            return CGSize(width: width, height: 78)
        }
        return CGSize(width: 114, height: 168)
    }
}