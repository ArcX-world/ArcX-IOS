//
// Created by LLL on 2024/3/16.
//

import UIKit
import SwiftyJSON

class ProfileViewController: BaseViewController {

    private let nameLabel = UILabel(text: nil, textColor: .white, fontSize: 14, weight: .heavy)
    private let genderView = UIImageView()
    private let attributesView = UserAttributesRadarView(frame: CGRect())
    private var collectionView: UICollectionView!
    private let navigationBar = UserNavigationBar()


    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .UserinfoDidChangeNotification, object: nil)
        commonInit()
        updateUI()

        Profile.loadCurrentProfile { _ in  }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if navigationController == nil {
            NotificationCenter.default.removeObserver(self)
        }
    }

    // MARK: - Private

    @objc private func settingsButtonClick() {
        present(SettingsViewController(), animated: true)
    }

    @objc private func infoViewTap(_ gesture: UIGestureRecognizer) {
        guard let _ = gesture.view else { return }
        let point = gesture.location(in: gesture.view)
        if point.y <= gesture.view!.frame.height * 0.5 {
            present(UsernameEditViewController(), animated: true)
        } else {
            present(GenderEditViewController(), animated: true)
        }
    }

    @objc private func updateUI() {
        guard let profile = Profile.current else { return }
        nameLabel.text = profile.plyNm
        genderView.image = UIImage(named: "img_gender_0\(profile.sex)")

        var attributes: [UserAttribute] = []
        if let attr = profile.atbTbln.first(where: { $0.atbTp == AttributeType.level.rawValue }) {
            attributes.append(attr)
        }
        if let attr = profile.atbTbln.first(where: { $0.atbTp == AttributeType.energy.rawValue }) {
            attributes.append(attr)
        }
        if let attr = profile.atbTbln.first(where: { $0.atbTp == AttributeType.charge.rawValue }) {
            attributes.append(attr)
        }
        if let attr = profile.atbTbln.first(where: { $0.atbTp == AttributeType.income.rawValue }) {
            attributes.append(attr)
        }
        if let attr = profile.atbTbln.first(where: { $0.atbTp == AttributeType.charm.rawValue }) {
            attributes.append(attr)
        }
        if let attr = profile.atbTbln.first(where: { $0.atbTp == AttributeType.lucky.rawValue }) {
            attributes.append(attr)
        }

        attributesView.attributes = attributes.map({ attr in
            if attr.atbTp == AttributeType.level.rawValue {
                return 1.0
            }
            return CGFloat(attr.sdNma) / CGFloat(attr.sdDma)
        })

        collectionView.reloadData()
    }

    private func commonInit() {
        title = "Mine"
        view.backgroundColor = UIColor(hex: 0xDEDBEE)


        let bgView = UIImageView(image: UIImage(named: "img_profile_bg"))
        view.insertSubview(bgView, at: 0)
        bgView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.equalToSuperview()
        }

        navigationBar.energyView.isHidden = true
        let settingsButton = UIButton(image: UIImage(named: "img_profile_settings"))
        settingsButton.addTarget(self, action: #selector(settingsButtonClick), for: .touchUpInside)
        navigationBar.addSubview(settingsButton)
        settingsButton.snp.makeConstraints { make in
            make.centerY.equalTo(navigationBar.gameTokenView)
            make.right.equalTo(-10)
        }

        view.addSubview(attributesView)
        attributesView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(0)
            make.right.equalTo(-26)
        }


        let infoView = UIImageView(image: UIImage(named: "img_profile_info"))
        infoView.isUserInteractionEnabled = true
        infoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(infoViewTap(_:))))
        view.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(22)
            make.left.equalTo(22)
            make.bottom.equalTo(bgView.snp.bottom).offset(-120)
        }

        let nameTitleLabel = UILabel(text: "Name", textColor: .white, fontSize: 14, weight: .heavy)
        infoView.addSubview(nameTitleLabel)
        nameTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(17)
            make.left.equalTo(15)
        }

        nameLabel.text = Profile.current?.plyNm
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.6
        infoView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(nameTitleLabel)
            make.right.equalTo(-18)
            make.width.lessThanOrEqualTo(90)
        }

        let genderTitleLabel = UILabel(text: "Gender", textColor: .white, fontSize: 14, weight: .heavy)
        infoView.addSubview(genderTitleLabel)
        genderTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTitleLabel.snp.bottom).offset(20)
            make.left.equalTo(nameTitleLabel)
        }


        infoView.addSubview(genderView)
        genderView.snp.makeConstraints { make in
            make.centerY.equalTo(genderTitleLabel)
            make.right.equalTo(-18)
            make.size.equalTo(30)
        }


        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 146, height: 128)
        flowLayout.estimatedItemSize = flowLayout.itemSize
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 24
        let marginLR = floor((view.frame.width - flowLayout.itemSize.width * 2 - flowLayout.minimumInteritemSpacing) * 0.5)
        flowLayout.sectionInset = UIEdgeInsets(top: 34, left: marginLR, bottom: 16, right: marginLR)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.transform = CGAffineTransform.identity.scaledBy(x: Dimensions.WLR, y: Dimensions.WLR)
        collectionView.register(UserAttributeViewCell.self, forCellWithReuseIdentifier: "cell")
        view.insertSubview(collectionView, at: 1)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(attributesView.snp.bottom).offset(18)
            make.width.equalTo(view.frame.width)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }

    }

}


// MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Profile.current?.atbTbln.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UserAttributeViewCell
        let attr = Profile.current!.atbTbln[indexPath.row]
        cell.configCell(attr)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let attr = Profile.current!.atbTbln[indexPath.row]
        if attr.upFlg {
            present(UserAttributeViewController(attr: attr), animated: true)
        }
    }
}
