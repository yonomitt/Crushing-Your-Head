//
//  CGImageExtension.swift
//  CGImageExtension
//
//  Created by Yonatan Mittlefehldt on 2021-21-07.
//

import CoreGraphics
import VideoToolbox

extension CGImage {
    static func create(from cvPixelBuffer: CVPixelBuffer?) -> CGImage? {
        guard let pixelBuffer = cvPixelBuffer else {
            return nil
        }

        var img: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer,
                                         options: nil,
                                         imageOut: &img)
        return img
    }
}
