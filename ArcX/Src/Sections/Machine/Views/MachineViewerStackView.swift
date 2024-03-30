//
// Created by LLL on 2024/3/22.
//

import UIKit

class MachineViewerStackView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    var dataSource: [MachinePlayer] = [] {
        didSet {
            collectionView.reloadData()
            isHidden = dataSource.isEmpty
        }
    }

    private var collectionView: UICollectionView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: 0x5FBED8)
        layer.cornerRadius = 22
        layer.masksToBounds = true
        isHidden = true

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 44, height: 44)
        flowLayout.estimatedItemSize = flowLayout.itemSize
        flowLayout.minimumInteritemSpacing = 4
        flowLayout.minimumLineSpacing = 4
        flowLayout.sectionInset = UIEdgeInsets()
        flowLayout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 60, height: 44), collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceHorizontal = true
        collectionView.register(MachineViewerViewCell.self, forCellWithReuseIdentifier: "cell")
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo(CGSize(width: 54, height: 44))
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MachineViewerViewCell
        cell.imageView.kf.setImage(with: URL(string: dataSource[indexPath.row].plyPct))
        return cell
    }

    // MARK: - UICollectionViewDelegate

}


private class MachineViewerViewCell: UICollectionViewCell {

    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        imageView.layer.cornerRadius = frame.height * 0.5
        imageView.layer.masksToBounds = true
        imageView.frame = bounds
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        contentView.addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}