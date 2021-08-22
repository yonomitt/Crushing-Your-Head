//
//  FaceDetector.swift
//  FaceDetector
//
//  Created by Yonatan Mittlefehldt on 2021-27-07.
//

import Vision

/// A Vision-based processor that handles detecting and tracking faces across frames
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

    /// Post processes the results returned by the Vision API.
    /// - Parameter requests: requests with results that were processed by the Vision API
    /// - Returns: an array of detected faces, either new or tracked
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

    /// Main function in this Vision-processor. It runs the input image through the Vision API and post processes the results
    /// to return an array of detected faces
    /// - Parameter image: input frame from the camera
    /// - Returns: an array of detected faces in the image
    func process(image: CVPixelBuffer?) throws -> [DetectedObject] {
        guard let image = image else {
            return []
        }

        // Create an empty array of Vision requests
        var requests = [VNRequest]()

        // Add tracking requests for any heads that are currently known
        for head in trackedHeads {
            requests.append(VNTrackObjectRequest(detectedObjectObservation: head.value))
        }

        // If no heads are currently known, fall back to a face detection request.
        // Also reset the sequence handler, as it may no longer have useful information
        // to help it detect faces.
        if requests.isEmpty {
            requests.append(detectionRequest)
            sequenceHandler = VNSequenceRequestHandler()
        }

        try sequenceHandler.perform(requests, on: image)

        return postProcess(requests: requests)
    }
}
