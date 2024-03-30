//
// Created by MAC on 2023/11/2.
//

import UIKit

extension UIView {

    func currentViewController() -> UIViewController? {
        var responder: UIResponder = self
        while let nextResponder = responder.next {
            responder = nextResponder
            if responder is UIViewController {
                return responder as? UIViewController
            }
        }
        return nil
    }


    static private let tapPlayer: AudioPlayer = {
        let player = AudioPlayer(fileName: "sound_default_click.mp3")!
        player.prepareToPlay()
        return player
    }()

    func addTapEffects() {
        if self is UIControl {
            (self as! UIControl).addTarget(self, action: #selector(tapEffects), for: .touchDown)
        } else {
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapEffects)))
        }
    }

    @objc func tapEffects() {
        Self.tapPlayer.play()
    }

}