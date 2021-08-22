//
//  FaceDetector.swift
//  FaceDetector
//
//  Created by Yonatan Mittlefehldt on 2021-27-07.
//

import Vision

class FaceDetector: VisionProcessor {
    static let shared = FaceDetector()

    private var sequenceHandler = VNSequenceRequestHandler()

    private var trackedHeads = [UUID: VNDetectedObjectObservation]()

    private let minimumConfidence: Float = 0.75

    private init() {}

    private lazy var detectionRequest: VNRequest = {
        let req = VNDetectFaceRectanglesRequest()
        req.regionOfInterest = CGRect(x: 0.2, y: 0.5, width: 0.6, height: 0.3)
        return req
    }()

    private func postProcess(requests: [VNRequest]) -> [DetectedObject] {
        var newTrackedHeads = [UUID: VNDetectedObjectObservation]()
        for request in requests {
            guard let results = request.results as? [VNDetectedObjectObservation] else {
                continue
            }

            for result in results where result.confidence >= minimumConfidence {
                newTrackedHeads[result.uuid] = result
            }
        }

        trackedHeads = newTrackedHeads

        return trackedHeads.values.map { DetectedObject(id: $0.uuid, bbox: $0.boundingBox) }
    }

    func process(image: CVPixelBuffer?) throws -> [DetectedObject] {
        guard let image = image else {
            return []
        }

        var requests = [VNRequest]()

        for head in trackedHeads {
            requests.append(VNTrackObjectRequest(detectedObjectObservation: head.value))
        }

        if requests.isEmpty {
            requests.append(detectionRequest)
            sequenceHandler = VNSequenceRequestHandler()
        }

        try sequenceHandler.perform(requests, on: image)

        return postProcess(requests: requests)
    }
}
