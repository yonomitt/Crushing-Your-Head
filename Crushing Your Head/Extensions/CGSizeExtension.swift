//
//  CGSizeExtension.swift
//  CGSizeExtension
//
//  Created by Yonatan Mittlefehldt on 2021-27-07.
//

import CoreGraphics

extension CGSize {
    static func * (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width * rhs.width, height: lhs.height * rhs.height)
    }

    /// Mirror a unit size about the x-axis
    var mirrorY: CGSize {
        CGSize(width: width, height: 1.0 - height)
    }
}
