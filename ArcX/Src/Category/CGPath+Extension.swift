//
// Created by MAC on 2024/1/20.
//

import UIKit

extension CGPath {

    func _applyWithBlock(_ block: @escaping @convention(block) (CGPathElement) -> Void) {
        typealias Body = @convention(block) (CGPathElement) -> Void
        let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { (info, element) in
            let body = unsafeBitCast(info, to: Body.self)
            body(element.pointee)
        }
        let unsafeBlock = unsafeBitCast(block, to: UnsafeMutableRawPointer.self)
        let unsafeFunction = unsafeBitCast(callback, to: CGPathApplierFunction.self)
        self.apply(info: unsafeBlock, function: unsafeFunction)
    }

    func getPathElementsPoints() -> [CGPoint] {
        var points: [CGPoint]! = [CGPoint]()
        _applyWithBlock { element in
            switch (element.type) {
            case CGPathElementType.moveToPoint:
                points.append(element.points[0])
            case .addLineToPoint:
                points.append(element.points[0])
            case .addQuadCurveToPoint:
                points.append(element.points[0])
                points.append(element.points[1])
            case .addCurveToPoint:
                points.append(element.points[0])
                points.append(element.points[1])
                points.append(element.points[2])
            default: break
            }
        }
        return points
    }

}
