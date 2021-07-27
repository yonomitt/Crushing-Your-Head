//
//  CGPointExtension.swift
//  CGPointExtension
//
//  Created by Yonatan Mittlefehldt on 2021-23-07.
//

import CoreGraphics

extension CGPoint {
    static func * (point: CGPoint, size: CGSize) -> CGPoint {
        CGPoint(x: point.x * size.width, y: point.y * size.height)
    }

    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        lhs + CGPoint(x: -rhs.x, y: -rhs.y)
    }

    var mirrorY: CGPoint {
        CGPoint(x: x, y: 1.0 - y)
    }
}
