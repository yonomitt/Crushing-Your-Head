//
//  CGImageExtension.swift
//  CGImageExtension
//
//  Created by Yonatan Mittlefehldt on 2021-21-07.
//

import CoreGraphics
import VideoToolbox

extension CGImage {
    /// Helper function to create a `CGImage` from a `CVPixelBuffer`. This is not guaranteed to
    /// work for all types of `CVPixelBuffer`. If it fails, it will return `nil`
    /// - Parameter cvPixelBuffer: input `CVPixelBuffer` to convert
    /// - Returns: a `CGImage` if the conversion was successful, `nil` otherwise
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
