//
// Created by LLL on 2024/3/13.
//

import UIKit
import SwiftyJSON

class MachineListViewController: BaseViewController {

    private var category: MachineCategory = .pusher
    private var dataSource: [Machine] = []
    private var collectionView: UICollectionView!
    private let navigationBar = UserNavigationBar()


    init(category: MachineCategory) {
        super.init(nibName: nil, bundle: nil)
        self.category = category
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        loadData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if navigationController == nil {

        }
    }

    // MARK: - Private

    private func loadData() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        machineProvider.request(.getMachines(type: category.rawValue, pageNum: 1, pageSize: 100)) { result in
            hud.hide()
            switch result {
            case .success(let response):
                do {
                    let array = try response.map(Array<Machine>.self, atKeyPath: "serverTbln")
                    self.dataSource = array
                    self.collectionView.reloadData()
                } catch {
                    logger.error(error)
                }
                break
            case .failure:
                break
            }
        }
    }

    @objc private func playButtonClick() {
        let hud = ProgressHUD.showHUD(addedTo: view)
        machineProvider.request(.getIdleMachine(category: category.rawValue)) { result in
            hud.hide()
            switch result {
            case .success(let response):
                do {
                    let id = try response.map(Int.self, atKeyPath: "serverMsg.devIfo.devId")
                    MachineViewController().present(with: id, in: self)
                } catch {}
                break
            case .failure(let error):
                break
            }
        }
    }

    private func commonInit() {
        view.backgroundColor = .black

        switch category {
        case .pusher: title = "Coin Pusher"
        case .claw: title = "Claw machine"
        case .gift: title = "Gift machine"
        }

        let bgView = UIImageView(image: UIImage(named: "img_main_blur_bg"))
        bgView.frame = view.bounds
        view.insertSubview(bgView, at: 0)

        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.snp.topMargin)
            make.left.right.equalToSuperview()
        }

        let playButton = UIButton(image: UIImage(named: "img_main_mch_play"))
        playButton.contentEdgeInsets = UIEdgeInsets()
        playButton.addTarget(self, action: #selector(playButtonClick), for: .touchUpInside)
        view.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.bottomNavigationBar)
            make.right.equalToSuperview()
        }


        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 191, height: 182)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets()

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        collectionView.register(MachineViewCell01.self, forCellWithReuseIdentifier: "MachineViewCell01")
        collectionView.register(MachineViewCell02.self, forCellWithReuseIdentifier: "MachineViewCell02")
        view.insertSubview(collectionView, at: 1)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(0)
            make.left.bottom.right.equalToSuperview()
        }

    }

}

// MARK: - UICollectionViewDataSource
extension MachineListViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if category == .pusher {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MachineViewCell01", for: indexPath) as! MachineViewCell01
            cell.configCell(dataSource[indexPath.row])
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MachineViewCell02", for: indexPath) as! MachineViewCell02
        cell.configCell(dataSource[indexPath.row])
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension MachineListViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if category == .pusher {
            return CGSize(width: 191, height: 182)
        }
        return CGSize(width: 323, height: 160)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if category == .pusher {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let marginLR = (collectionView.frame.width - flowLayout.itemSize.width * 2) * 0.5
            return UIEdgeInsets(top: 10, left: marginLR, bottom: 10, right: marginLR)
        }
        return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if category == .pusher {
            return 0
        }
        return 16
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let machine = dataSource[indexPath.row]
        MachineViewController().present(with: machine.devId, in: self)
    }

}
