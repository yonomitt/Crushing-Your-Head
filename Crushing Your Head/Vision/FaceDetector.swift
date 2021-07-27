//
//  FaceDetector.swift
//  FaceDetector
//
//  Created by Yonatan Mittlefehldt on 2021-27-07.
//

import Vision

class FaceDetector: VisionProcessor {
    static let shared = FaceDetector()

    private init() {}

    private lazy var request: VNRequest = {
        let req = VNDetectFaceRectanglesRequest()
        return req
    }()

    private func postProcess(request: VNRequest) -> [Head] {
        guard let results = request.results as? [VNFaceObservation] else {
            return []
        }

        return results.map { Head(id: $0.uuid, bbox: $0.boundingBox) }
    }

    func process(image: CVPixelBuffer?) throws -> [Head] {
        guard let image = image else {
            return []
        }

        let faceDetectRequest = try perform(request, on: image)

        return postProcess(request: faceDetectRequest)
    }
}
