//
// Created by LLL on 2024/3/29.
//

import UIKit

class NFTReportViewController: BaseViewController {


    private var dataSource: [NFTEarnItem] = []
    private var pageNum: Int = 0

    private let totalLabel = CustomLabel()
    private var collectionView: UICollectionView!


    var nft: BackpackNFTDetails!
    init(nft: BackpackNFTDetails) {
        super.init(nibName: nil, bundle: nil)
        self.nft = nft
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        collectionView.rf_footer?.beginRefreshing()
    }


    // MARK: -

    @objc private func loadData() {
        let pageNum = pageNum + 1
        let pageSize: Int = 10
        nftProvider.request(.getNFTReport(identifier: nft.nftCd, pageNum: pageNum, pageSize: pageSize)) { result in
            switch result {
            case .success(let response):
                do {
                    let total = try response.map(Double.self, atKeyPath: "serverMsg.ttAmt")
                    self.totalLabel.text = NSNumber(value: total).formatted(style: .decimal)

                    let array = try response.map(Array<NFTEarnItem>.self, atKeyPath: "serverMsg.opTbln")
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
        title = "Report"
        view.layer.contents = UIImage.gradient(colors: [ UIColor(hex: 0xC6B1FF), UIColor(hex: 0xFFEDE0), UIColor(hex: 0xDDC6F6), UIColor(hex: 0x8A8DCF) ], size: view.frame.size, end: CGPoint(x: 0, y: 1)).cgImage

        let topView = UIView()
        topView.backgroundColor = UIColor(hex: 0xCBB6FC)
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }

        let sectionView = UIImageView()
        sectionView.image = UIImage(named: "img_nft_earn_bg")
        sectionView.isUserInteractionEnabled = true
        topView.addSubview(sectionView)
        sectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.topMargin).offset(20)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-22)
        }

        let titleLabel = UILabel(text: "Total earn", textColor: .white, fontSize: 16, weight: .bold)
        sectionView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(22)
        }

        totalLabel.fonts = CustomLabel.Fonts.gold
        totalLabel.fontSize = 27
        totalLabel.text = "0"
        sectionView.addSubview(totalLabel)
        totalLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(16)
            make.centerY.equalToSuperview().offset(16)
        }

        let tokenView = UIImageView(image: UIImage(named: "img_usdt_token"))
        sectionView.addSubview(tokenView)
        tokenView.snp.makeConstraints { make in
            make.centerY.equalTo(totalLabel)
            make.right.equalTo(totalLabel.snp.left).offset(-4)
            make.size.equalTo(30)
        }


        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: view.frame.width - 16 * 2, height: 170)
        flowLayout.estimatedItemSize = flowLayout.itemSize
        flowLayout.minimumInteritemSpacing = 16
        flowLayout.minimumLineSpacing = 16
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.rf_footer = RefreshNormalFooter(target: self, action: #selector(loadData))
        collectionView.register(NFTEarnViewCell.self, forCellWithReuseIdentifier: "NFTEarnViewCell")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }

    }


}



// MARK: - UICollectionViewDataSource
extension NFTReportViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NFTEarnViewCell", for: indexPath) as! NFTEarnViewCell
        cell.configCell(dataSource[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension NFTReportViewController: UICollectionViewDelegate {

}