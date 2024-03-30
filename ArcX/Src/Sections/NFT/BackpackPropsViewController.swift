//
// Created by LLL on 2024/3/30.
//

import UIKit

class BackpackPropsViewController: BaseViewController {

    private var dataSource: [BackpackProp] = []
    private var pageNum: Int = 0

    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadItems), name: .BackpackPropDidChangeNotification, object: nil)
        commonInit()
        reloadItems()
    }

    // MARK: -

    @objc private func reloadItems() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        let pageNum = 1
        let pageSize = 20
        userProvider.request(.getBackpackProps(pageNum: pageNum, pageSize: pageSize)) { result in
            hud.hide()
            switch result {
            case .success(let response):
                do {
                    let array = try response.map(Array<BackpackProp>.self, atKeyPath: "serverTbln")
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
        userProvider.request(.getBackpackProps(pageNum: pageNum, pageSize: pageSize)) { result in
            switch result {
            case .success(let response):
                do {
                    let array = try response.map(Array<BackpackProp>.self, atKeyPath: "serverTbln")
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
        flowLayout.itemSize = CGSize(width: 60, height: 60)
        flowLayout.estimatedItemSize = flowLayout.itemSize
        flowLayout.minimumLineSpacing = 8
        let marginLR = floor((view.frame.width - flowLayout.itemSize.width * 5) / 6.0)
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
        collectionView.register(BackpackPropViewCell.self, forCellWithReuseIdentifier: "BackpackPropViewCell")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }

}


// MARK: - UICollectionViewDataSource
extension BackpackPropsViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackpackPropViewCell", for: indexPath) as! BackpackPropViewCell
        cell.configCell(dataSource[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDataSource
extension BackpackPropsViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let prop = dataSource[indexPath.row]
        present(BackpackPropViewController(prop: prop), animated: true)
    }
}