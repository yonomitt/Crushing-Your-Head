//
//  CGRectExtension.swift
//  CGRectExtension
//
//  Created by Yonatan Mittlefehldt on 2021-23-07.
//

import CoreGraphics

extension CGRect {
    /// Calculates a `CGRect` centered at a point with a specific size
    /// - Parameters:
    ///   - point: the center of the output `CGRect`
    ///   - size: the size of the output `CGRect`
    /// - Returns: a `CGRect` centered at `point` with a size `size`
    static func centered(at point: CGPoint, with size: CGFloat) -> CGRect {
        let half = size / 2
        return CGRect(x: point.x - half, y: point.y - half, width: size, height: size)
    }
}
