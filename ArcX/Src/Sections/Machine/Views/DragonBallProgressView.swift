//
// Created by LLL on 2024/3/14.
//

import UIKit

class DragonBallProgressView: UIImageView {

    var value: Int = 0 {
        didSet {
            for i in 0..<ballViews.count {
                ballViews[i].isHighlighted = i < value
            }
        }
    }

    var ballViews: [UIImageView] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        image = UIImage(named: "img_db_bar")

        for _ in 0..<7 {
            let ballView = UIImageView(image: UIImage(named: "img_db_ball_gray"))
            ballView.highlightedImage = UIImage(named: "img_db_ball")
            ballViews.append(ballView)
        }

        let stackView = UIStackView(arrangedSubviews: ballViews)
        stackView.axis = .horizontal
        stackView.spacing = 4
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.left.equalTo(4)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
