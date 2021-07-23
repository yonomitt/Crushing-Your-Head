//
//  CGRectExtension.swift
//  CGRectExtension
//
//  Created by Yonatan Mittlefehldt on 2021-23-07.
//

import CoreGraphics

extension CGRect {
    static func centered(at point: CGPoint, with size: CGFloat) -> CGRect {
        let half = size / 2
        return CGRect(x: point.x - half, y: point.y - half, width: size, height: size)
    }
}
