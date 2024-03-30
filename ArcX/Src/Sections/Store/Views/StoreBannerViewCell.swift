//
// Created by LLL on 2024/3/20.
//

import UIKit

class StoreBannerViewCell: UICollectionViewCell {

    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        contentView.clipsToBounds = true

        imageView.frame = bounds
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }


    func configCell(_ url: String) {
        imageView.kf.setImage(with: URL(string: url))
    }
}
