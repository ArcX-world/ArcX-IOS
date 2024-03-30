//
// Created by MAC on 2023/11/4.
//

import UIKit

class CustomLabel: UIView {

    var text: String? {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }

    var fonts: [String: UIImage] = Fonts.orange

    var fontSize: CGFloat = 20 {
        didSet {
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if let string = text {
            var x: CGFloat = 0
            let images = mapImages(string)
            for image in images {
                let w = image.size.width / image.size.height * fontSize
                image.draw(in: CGRect(x: x, y: 0, width: w, height: fontSize))
                x += w
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        if let string = text {
            let images = mapImages(string)
            let width = images.reduce(0, { $0 + $1.size.width / $1.size.height * fontSize })
            return CGSize(width: width, height: fontSize)
        }
        return super.intrinsicContentSize
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        if let string = text {
            let images = mapImages(string)
            let width = images.reduce(0, { $0 + $1.size.width / $1.size.height * fontSize })
            return CGSize(width: width, height: fontSize)
        }
        return super.sizeThatFits(size)
    }


    private func mapImages(_ string: String) -> [UIImage] {
        var images: [UIImage] = []
        for char in string {
            if let img = fonts["\(char)"] {
                images.append(img)
            } else {
                let img = UIImage.pure(color: .clear, size: CGSize(width: fontSize * 0.2, height: fontSize))
                images.append(img)
            }
        }
        return images
    }

}

extension CustomLabel {

    struct Fonts {

        static let orange: [String: UIImage] = [
            "0": UIImage(named: "img_font_orange_0")!,
            "1": UIImage(named: "img_font_orange_1")!,
            "2": UIImage(named: "img_font_orange_2")!,
            "3": UIImage(named: "img_font_orange_3")!,
            "4": UIImage(named: "img_font_orange_4")!,
            "5": UIImage(named: "img_font_orange_5")!,
            "6": UIImage(named: "img_font_orange_6")!,
            "7": UIImage(named: "img_font_orange_7")!,
            "8": UIImage(named: "img_font_orange_8")!,
            "9": UIImage(named: "img_font_orange_9")!,
            ",": UIImage(named: "img_font_orange_comma")!,
            ".": UIImage(named: "img_font_orange_point")!,
        ]

        static let blue: [String: UIImage] = [
            "0": UIImage(named: "img_font_blue_0")!,
            "1": UIImage(named: "img_font_blue_1")!,
            "2": UIImage(named: "img_font_blue_2")!,
            "3": UIImage(named: "img_font_blue_3")!,
            "4": UIImage(named: "img_font_blue_4")!,
            "5": UIImage(named: "img_font_blue_5")!,
            "6": UIImage(named: "img_font_blue_6")!,
            "7": UIImage(named: "img_font_blue_7")!,
            "8": UIImage(named: "img_font_blue_8")!,
            "9": UIImage(named: "img_font_blue_9")!,
            ",": UIImage(named: "img_font_blue_comma")!,
            ".": UIImage(named: "img_font_blue_point")!,
        ]

        static let gold: [String: UIImage] = [
            "0": UIImage(named: "img_font_gold_0")!,
            "1": UIImage(named: "img_font_gold_1")!,
            "2": UIImage(named: "img_font_gold_2")!,
            "3": UIImage(named: "img_font_gold_3")!,
            "4": UIImage(named: "img_font_gold_4")!,
            "5": UIImage(named: "img_font_gold_5")!,
            "6": UIImage(named: "img_font_gold_6")!,
            "7": UIImage(named: "img_font_gold_7")!,
            "8": UIImage(named: "img_font_gold_8")!,
            "9": UIImage(named: "img_font_gold_9")!,
            ",": UIImage(named: "img_font_gold_comma")!,
            ".": UIImage(named: "img_font_gold_point")!,
            "X": UIImage(named: "img_font_gold_X")!,
        ]
    }

}
