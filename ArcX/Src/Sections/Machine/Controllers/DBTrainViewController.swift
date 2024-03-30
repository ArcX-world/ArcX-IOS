//
// Created by LLL on 2024/3/19.
//

import UIKit

class DBTrainViewController: BaseAlertController {

    var trainMsg: DBTrain!

    private var queue: [Int] = []
    private var displayLink: CADisplayLink?
    private var displayLink2: CADisplayLink?
    private var runPlayer: AudioPlayer?

    private let trainView = UIImageView()
    private var cells: [DBTrainViewCell] = []

    init(train: DBTrain) {
        super.init(nibName: nil, bundle: nil)
        trainMsg = train
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        commonInit()
        queue = trainMsg.icAwdTbln.map({ $0.awdInx })
        AudioPlayer(fileName: "sound_dbt_show.mp3")?.play()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isBeingPresented {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.run()
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayLink?.invalidate()
        displayLink2?.invalidate()
    }

    override var isEnqueueForPresentation: Bool {
        return true
    }


    // MARK: - Private

    private var offset: Int = 0
    private var targetOffset: Int = 0

    private func run() {
        if let idx = queue.first {
            queue.removeFirst()

            offset = offset % 16
            targetOffset = 16 * 3 + offset
            if offset <= idx {
                targetOffset += (idx - offset)
            } else {
                targetOffset += (idx + (16 - offset))
            }
            displayLink?.invalidate()
            displayLink = CADisplayLink(target: self, selector: #selector(handleRun))
            displayLink?.preferredFramesPerSecond = 20
            displayLink?.add(to: .main, forMode: .common)

            if runPlayer == nil {
                runPlayer = AudioPlayer(fileName: "sound_dbt_run.mp3", loops: -1)?.play()
            }

            if displayLink2 == nil {
                displayLink2 = CADisplayLink(target: self, selector: #selector(handleTrain))
                displayLink2?.preferredFramesPerSecond = 2
                displayLink2?.add(to: .main, forMode: .common)
            }
        }
        else {
            weak var presentingViewController = presentingViewController
            presentingViewController?.dismiss(animated: true) {
                presentingViewController?.present(DBTrainBonusViewController(bonusItems: self.trainMsg.awdTbln), animated: true)
            }
        }
    }

    @objc private func handleRun() {
        offset += 1
        let index = offset % 16
        cells[index].highlight()
        if offset == targetOffset {
            cells[index].select(completion: { self.run() })
            displayLink?.invalidate()
            runPlayer?.stop()
            runPlayer = nil
        }
    }

    @objc private func handleTrain() {
        trainView.isHighlighted = !trainView.isHighlighted
    }

    private func commonInit() {
        let contentView = UIView()
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(view.frame.width)
        }

        let titleView = UIImageView(image: UIImage(named: "img_dbt_title"))
        contentView.addSubview(titleView)
        titleView.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }

        trainView.image = UIImage(named: "img_dbt_train_01")
        trainView.highlightedImage = UIImage(named: "img_dbt_train_02")
        contentView.addSubview(trainView)
        trainView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(14)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }


        let size: CGFloat = 50
        let spacing: CGFloat = 6
        for i in 0..<16 {
            var x: CGFloat = 34
            var y: CGFloat = 33
            if i < 5 {
                x += (size + spacing) * CGFloat(i)
            } else if i < 9 {
                x += (size + spacing) * 4.0
                y += (size + spacing) * CGFloat(i - 4)
            } else if i < 13 {
                x += (size + spacing) * CGFloat(12 - i)
                y += (size + spacing) * 4.0
            } else {
                y += (size + spacing) * CGFloat(16 - i)
            }

            let cell = DBTrainViewCell(frame: CGRect(x: x, y: y, width: size, height: size))
            cell.iconView.kf.setImage(with: URL(string: trainMsg.icTbln[i]))
            trainView.addSubview(cell)
            cells.append(cell)
        }

    }


}


private class DBTrainViewCell: UIView {

    let iconView = UIImageView(image: UIImage(named: "img_axc_token"))
    let selectedView = UIImageView(image: UIImage(named: "img_dbt_cell_selected"))
    let highlightedView = UIImageView(image: UIImage(named: "img_dbt_cell_highlighted"))

    override init(frame: CGRect) {
        super.init(frame: frame)

        let bgView = UIImageView(image: UIImage(named: "img_dbt_cell"))
        bgView.frame = bounds
        addSubview(bgView)

        selectedView.isHidden = true
        selectedView.frame = bounds
        addSubview(selectedView)

        iconView.frame = CGRect(x: 0, y: 0, width: 28, height: 28)
        iconView.center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
        iconView.contentMode = .scaleAspectFit
        addSubview(iconView)

        highlightedView.isHidden = true
        highlightedView.frame = bounds
        addSubview(highlightedView)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Public Methods

    func select(completion: @escaping () -> Void) {
        selectedView.isHidden = false
        highlightedView.isHidden = false
        highlightedView.alpha = 1.0

        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = NSNumber(value: 1.0)
        animation.toValue = NSNumber(value: 0.1)
        animation.repeatCount = 6
        animation.duration = 0.3
        animation.autoreverses = true
        animation.fillMode = .forwards
        highlightedView.layer.add(animation, forKey: "ani")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.highlightedView.isHidden = true
            self?.highlightedView.layer.removeAnimation(forKey: "ani")
            completion()
        }
    }

    func highlight() {
        highlightedView.isHidden = false
        highlightedView.alpha = 1.0
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.highlightedView.alpha = 0.0
        }, completion: { b in

        })
    }

}