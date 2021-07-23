//
//  HandPoseDetector.swift
//  HandPoseDetector
//
//  Created by Yonatan Mittlefehldt on 2021-23-07.
//

import Vision

class HandPoseDetector: VisionProcessor {
    static let shared = HandPoseDetector()

    private init() {}

    private lazy var request: VNRequest = {
        let req = VNDetectHumanHandPoseRequest()
        req.maximumHandCount = 1
        return req
    }()

    /// Post-processes the returned request from the Vision framework and convert the result to the
    /// proper datatype
    /// - Parameters:
    ///   - request: request that has already been run through the Vision framework
    /// - Returns: `Pinch` structure describing a detected index finger tip and the thumb tip
    private func postProcess(request: VNRequest) -> Pinch? {
        guard let results = request.results as? [VNHumanHandPoseObservation],
              let result = results.first else {
            return nil
        }

        return Pinch(from: result)
    }

    /// Process an image using the Vision framework's hand pose detection algorithm
    /// - Parameters:
    ///   - image: input image with a potential hand
    /// - Throws: rethrows the error from the Vision framework
    /// - Returns: an optional `Pinch` structure with the position of the detected landmarks for the
    ///            index finger tip and the thumb tip
    func process(image: CVPixelBuffer?) throws -> Pinch? {
        guard let image = image else {
            return nil
        }

        let handPoseRequest = try perform(request, on: image)

        return postProcess(request: handPoseRequest)
    }
}
