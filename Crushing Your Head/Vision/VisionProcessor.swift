//
//  VisionProcessor.swift
//  VisionProcessor
//
//  Created by Yonatan Mittlefehldt on 2021-23-07.
//

import CoreImage
import Vision

/// Helpful protocol to conform Vision-based processors/detectors
protocol VisionProcessor {
    func perform(_ request: VNRequest, on image: CVPixelBuffer) throws -> VNRequest
}

extension VisionProcessor {
    /// Performs a request on an input `CVPixelBuffer`
    /// - Parameters:
    ///   - request: Vision request to perform
    ///   - image: input image
    /// - Throws: rethrows the error from the Vision framework
    /// - Returns: the Vision request with the results field populated
    func perform(_ request: VNRequest, on image: CVPixelBuffer) throws -> VNRequest {
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: image, options: [:])
        try requestHandler.perform([request])
        return request
    }
}
