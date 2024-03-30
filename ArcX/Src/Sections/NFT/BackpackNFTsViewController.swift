//
// Created by LLL on 2024/3/30.
//

import UIKit

class BackpackNFTsViewController: BaseViewController {

    private var dataSource: [BackpackNFT] = []
    private var pageNum: Int = 0

    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadItems), name: .BackpackNFTDidChangeNotification, object: nil)
        commonInit()
        reloadItems()
    }


    @objc private func reloadItems() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        let pageNum = 1
        let pageSize = 20
        userProvider.request(.getBackpackNFTs(pageNum: pageNum, pageSize: pageSize)) { result in
            hud.hide()
            switch result {
            case .success(let response):
                do {
                    let array = try response.map(Array<BackpackNFT>.self, atKeyPath: "serverTbln")
                    self.pageNum = pageNum
                    self.dataSource = array
                    self.collectionView.reloadData()

                    self.collectionView.rf_header?.endRefreshing()
                    if array.count < pageSize {
                        self.collectionView.rf_footer?.endRefreshingWithNoMore()
                    }
                } catch {
                    logger.error(error)
                }
                break
            case .failure(let error):
                self.collectionView.rf_footer?.endRefreshingWithNoMore()
                break
            }
        }
    }

    @objc private func loadItems() {
        let pageNum = pageNum + 1
        let pageSize = 20
        userProvider.request(.getBackpackNFTs(pageNum: pageNum, pageSize: pageSize)) { result in
            switch result {
            case .success(let response):
                do {
                    let array = try response.map(Array<BackpackNFT>.self, atKeyPath: "serverTbln")
                    let indexPaths = array.enumerated().map({ IndexPath(row: self.dataSource.count + $0.offset, section: 0) })
                    self.dataSource += array
                    self.collectionView.insertItems(at: indexPaths)
                    self.pageNum = pageNum

                    if array.count < pageSize {
                        self.collectionView.rf_footer?.endRefreshingWithNoMore()
                    } else {
                        self.collectionView.rf_footer?.endRefreshing()
                    }
                } catch {
                    logger.error(error)
                }
                break
            case .failure(let error):
                self.collectionView.rf_footer?.endRefreshingWithNoMore()
                break
            }
        }
    }


    private func commonInit() {
        view.backgroundColor = .clear

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 166, height: 187)
        flowLayout.estimatedItemSize = flowLayout.itemSize
        flowLayout.minimumLineSpacing = 8
        let marginLR = floor((view.frame.width - flowLayout.itemSize.width * 2) / 3.0)
        flowLayout.minimumInteritemSpacing = marginLR
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: marginLR, bottom: 16, right: marginLR)
        flowLayout.alignment = .left

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        collectionView.rf_header = RefreshNormalHeader(target: self, action: #selector(reloadItems))
        collectionView.rf_footer = RefreshNormalFooter(target: self, action: #selector(loadItems))
        collectionView.register(BackpackNFTViewCell.self, forCellWithReuseIdentifier: "BackpackNFTViewCell")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }

}

// MARK: - UICollectionViewDataSource
extension BackpackNFTsViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackpackNFTViewCell", for: indexPath) as! BackpackNFTViewCell
        cell.configCell(dataSource[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDataSource
extension BackpackNFTsViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let nft = dataSource[indexPath.row]

        let hud = ProgressHUD.showHUD(addedTo: view)
        nftProvider.request(.getBackpackNFT(identifier: nft.nftCd)) { result in
            hud.hide()
            switch result {
            case .success(let response):
                do {
                    let details = try response.map(BackpackNFTDetails.self, atKeyPath: "serverMsg")
                    self.show(BackpackNFTDetailsViewController(nft: details), sender: nil)
                } catch {
                    logger.error(error)
                }
                break
            case .failure(let error):
                break
            }
        }
    }
}
