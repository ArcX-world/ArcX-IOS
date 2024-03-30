//
// Created by MAC on 2023/11/2.
//

import UIKit

extension UIImage {

    static func pure(color: UIColor, size: CGSize, borderWidth: CGFloat = 0, borderColor: UIColor = .clear, cornerRadius: CGFloat = 0, corners: UIRectCorner = UIRectCorner.allCorners) -> UIImage {
        let drawRect = CGRect(origin: .zero, size: size)

        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)

        context.setStrokeColor(borderColor.cgColor)
        context.setLineWidth(borderWidth)

        let path = UIBezierPath(roundedRect: drawRect.insetBy(dx: borderWidth * 0.5, dy: borderWidth * 0.5), byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        context.addPath(path.cgPath)
        context.drawPath(using: .fillStroke)

        var image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        image = image.resizableImage(withCapInsets: UIEdgeInsets(top: size.height * 0.4, left: size.width * 0.4, bottom: size.height * 0.4, right: size.width * 0.4), resizingMode: .stretch)
        return image
    }

    static func gradient(colors: [UIColor], locations: [CGFloat]? = nil, size: CGSize, start: CGPoint = CGPoint(x: 0, y: 0), end: CGPoint = CGPoint(x: 1, y: 0), cornerRadius: CGFloat = 0, corners: UIRectCorner = .allCorners) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()!
        context.saveGState()

        if cornerRadius > 0 {
            let rect = CGRect(origin: .zero, size: size)
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            context.addPath(path.cgPath)
            context.clip()
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colorComponents: [CGFloat] = colors.map{ $0.components }.flatMap{ $0 }
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: colorComponents, locations: locations, count: colors.count)!

        let startPoint = CGPoint(x: size.width * start.x, y: size.height * start.y)
        let endPoint = CGPoint(x: size.width * end.x, y: size.height * end.y)
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])

        let image = UIGraphicsGetImageFromCurrentImageContext()!

        context.restoreGState()
        UIGraphicsEndImageContext()

        return image
    }

    func resizeImage(withSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        self.draw(in: CGRect(origin: CGPoint(), size: size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    func resizeImage(withWidth width: CGFloat) -> UIImage {
        let height = width / (size.width / size.height)
        return resizeImage(withSize: CGSize(width: width, height: height))
    }


}