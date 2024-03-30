//
// Created by MAC on 2023/11/20.
//

import UIKit

class MachineButton: UIButton {

    private var listeners: [Listener] = []
    private var touchDownTime: Date = Date(timeIntervalSince1970: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = false
        addTarget(self, action: #selector(onTouchDown(_:event:)), for: .touchDown)
        addTarget(self, action: #selector(onTouchUp(_:event:)), for: .touchUpInside)
        addTarget(self, action: #selector(onTouchUp(_:event:)), for: .touchUpOutside)
        addTarget(self, action: #selector(onTouchUp(_:event:)), for: .touchCancel)
        addTarget(self, action: #selector(onDrag(_:event:)), for: .touchDragInside)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview == nil {
            stop()
        }
    }

    // MARK: - Public

    func add(listener: Listener) {
        listeners.append(listener)
    }

    func stop() {
        for listener in listeners {
            if let longPressListener = listener as? LongPressListener {
                longPressListener.timer?.invalidate()
                longPressListener.timer = nil
            }
            else if let automaticListener = listener as? AutomaticListener {
                automaticListener.timer?.invalidate()
                automaticListener.timer = nil
                if automaticListener.isAuto {
                    automaticListener.isAuto = false
                    automaticListener.onEnd?()
                }
            }
        }
        isHighlighted = false
    }

    // MARK: - Private

    @objc private func onTouchDown(_ sender: UIButton, event: UIEvent) {
        touchDownTime = Date()

        for listener in listeners {
            if let clickListener = listener as? TouchDownListener {
                clickListener.callback()
            }
            else if let longPressListener = listener as? LongPressListener {
                longPressListener.timer = Timer.scheduledTimer(withTimeInterval: longPressListener.interval, repeats: true) { _ in
                    longPressListener.callback()
                }
            }
            else if let automaticListener = listener as? AutomaticListener {
                automaticListener.timer?.invalidate()
                automaticListener.timer = nil
                if automaticListener.isAuto {
                    automaticListener.isAuto = false
                    automaticListener.onEnd?()
                }

                if automaticListener.isTrack {
                    automaticListener.autoView.center = event.allTouches?.first?.location(in: self) ?? center
                } else {
                    automaticListener.autoView.center = CGPoint(x: frame.width * 0.5, y: frame.height * 0.5)
                }
                automaticListener.animationTimer?.invalidate()
                automaticListener.animationTimer = Timer.scheduledTimer(withTimeInterval: automaticListener.threshold - 1.0, repeats: false) { _ in
                    self.addSubview(automaticListener.autoView)
                    //automaticListener.autoView.startAnimation()
                }
            }
        }
    }

    @objc private func onTouchUp(_ sender: UIButton, event: UIEvent) {
        for listener in listeners {
            if let clickListener = listener as? TouchDownListener {
                if clickListener.interval > 0 {
                    isEnabled = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + clickListener.interval) { self.isEnabled = true }
                }
            }
            else if let touchUpListener = listener as? TouchUpListener {
                touchUpListener.callback()
            }
            else if let longPressListener = listener as? LongPressListener {
                longPressListener.timer?.invalidate()
                longPressListener.timer = nil
            }
            else if let automaticListener = listener as? AutomaticListener {
                automaticListener.animationTimer?.invalidate()
                //automaticListener.autoView.stopAnimation()
                automaticListener.autoView.removeFromSuperview()

                let now = Date()
                if now.timeIntervalSince(touchDownTime) > automaticListener.threshold {
                    automaticListener.isAuto = true
                    automaticListener.onBegin?()
                    DispatchQueue.main.async { self.isHighlighted = true }

                    let repeats = automaticListener.interval > 0
                    automaticListener.timer = Timer.scheduledTimer(withTimeInterval: automaticListener.interval, repeats: repeats) { _ in
                        automaticListener.callback()
                    }
                }
            }
        }

    }

    @objc private func onDrag(_ sender: UIButton, event: UIEvent) {
        for listener in listeners {
            if let automaticListener = listener as? AutomaticListener {
                if automaticListener.isTrack {
                    automaticListener.autoView.center = event.allTouches?.first?.location(in: self) ?? center
                }
            }
        }
    }

}


extension MachineButton {

    typealias ListenerCallback = () -> Void


    class Listener {
        let callback: ListenerCallback

        init(callback: @escaping ListenerCallback) {
            self.callback = callback
        }
    }

    class TouchDownListener: Listener {

        let interval: TimeInterval

        init(interval: TimeInterval, callback: @escaping ListenerCallback) {
            self.interval = interval
            super.init(callback: callback)
        }
    }

    class TouchUpListener: Listener {

    }

    class LongPressListener: Listener {

        let interval: TimeInterval
        fileprivate var timer: Timer?

        init(interval: TimeInterval, callback: @escaping ListenerCallback) {
            self.interval = interval
            super.init(callback: callback)
        }
    }

    class AutomaticListener: Listener {

        let threshold: TimeInterval
        let interval: TimeInterval
        let onBegin: ListenerCallback?
        let onEnd: ListenerCallback?
        let isTrack: Bool

        fileprivate var animationTimer: Timer?
        fileprivate var timer: Timer?
        fileprivate var isAuto: Bool = false
        private var _autoView: UIView!

        init(threshold: TimeInterval, interval: TimeInterval, isTrack: Bool = false, callback: @escaping ListenerCallback, onBegin: ListenerCallback? = nil, onEnd: ListenerCallback? = nil) {
            self.threshold = threshold
            self.interval = interval
            self.onBegin = onBegin
            self.onEnd = onEnd
            self.isTrack = isTrack
            super.init(callback: callback)
        }

        var autoView: UIView {
            if _autoView == nil {
                _autoView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
//                _autoView = SVGAPlayer(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
//                _autoView.loops = 1
//                _autoView.clearsAfterStop = false
//                _autoView.isUserInteractionEnabled = false
//                SVGAParser().parse(withNamed: "ani_ps_auto", in: nil) { videoItem in
//                    self._autoView.videoItem = videoItem
//                }
            }
            return _autoView
        }
    }

}
