//
// Created by LLLi on 2022/8/16.
//

import UIKit
import ObjectiveC

extension NSAttributedString.Key {
    static let link: NSAttributedString.Key = NSAttributedString.Key(rawValue: "DLLinkAttributeName")
}

protocol AttributedLabelDelegate: NSObjectProtocol {
    func attributedLabel( label: AttributedLabel, didTap link: String, in range: NSRange)
}

class AttributedLabel: UILabel {

    weak var delegate: AttributedLabelDelegate?

    private let textContainer = NSTextContainer()

    private let layoutManager = NSLayoutManager()

    private let textStorage = NSTextStorage()

    init() {
        super.init(frame: CGRect())
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
        isUserInteractionEnabled = true

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func add(link: String, range: NSRange, textColor: UIColor) {
        self.add(link: link, range: range, attributes: [ NSAttributedString.Key.foregroundColor: textColor ])
    }

    func add(link: String, range: NSRange, attributes: [NSAttributedString.Key : Any]) {
        var attrs = attributes
        attrs[.link] = link

        let text = attributedText ?? NSAttributedString(string: text ?? "")
        let mText = NSMutableAttributedString(attributedString: text)
        mText.addAttributes(attrs, range: range)
        attributedText = mText
    }

    func append(text: String, textColor: UIColor? = nil) {
        var attributes: [NSAttributedString.Key : Any] = [:]
        if let color = textColor {
            attributes[.foregroundColor] = color
        }
        append(attrString: NSAttributedString(string: text, attributes: attributes))
    }

    func append(link: String, text: String, textColor: UIColor) {
        var attributes: [NSAttributedString.Key : Any] = [:]
        attributes[.foregroundColor] = textColor
        attributes[.link] = link
        append(attrString: NSAttributedString(string: text, attributes: attributes))
    }

    func append(image: UIImage, bounds: CGRect) {
        let attach = NSTextAttachment()
        attach.image = image
        attach.bounds = bounds
        append(attrString: NSAttributedString(attachment: attach))
    }

    func append(attrString: NSAttributedString) {
        let text = attributedText ?? NSAttributedString(string: text ?? "")
        let mText = NSMutableAttributedString(attributedString: text)
        mText.append(attrString)
        attributedText = mText
    }


    @objc
    private func handleTap(_ gesture: UITapGestureRecognizer) {
        textContainer.size = bounds.size
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineBreakMode = lineBreakMode

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = textAlignment

        if let attributedText = attributedText {
            let text = NSMutableAttributedString(attributedString: attributedText)
            text.enumerateAttributes(in: NSRange(location: 0, length: text.length)) { dictionary, range, pointer in
                if dictionary[NSAttributedString.Key.font] == nil {
                    text.addAttribute(NSAttributedString.Key.font, value: font as Any, range: range)
                }
                if dictionary[NSAttributedString.Key.paragraphStyle] == nil {
                    text.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
                }
            }
            textStorage.setAttributedString(text)
        }

        let location = gesture.location(in: self)
        let index = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        if index < textStorage.length {
            var range: NSRange! = NSRange()
            let link = attributedText?.attribute(.link, at: index, effectiveRange: &range)
            if let link = link {
                delegate?.attributedLabel(label: self, didTap: link as! String, in: range)
            }
        }
    }

}

