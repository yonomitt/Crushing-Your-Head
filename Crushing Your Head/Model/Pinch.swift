//
//  Pinch.swift
//  Pinch
//
//  Created by Yonatan Mittlefehldt on 2021-23-07.
//

import CoreGraphics
import Vision

struct Pinch {
    let top: CGPoint
    let bottom: CGPoint

    private init(top: CGPoint, bottom: CGPoint) {
        self.top = top
        self.bottom = bottom
    }

    init?(from observation: VNHumanHandPoseObservation) {
        guard let indexTip = try? observation.recognizedPoint(.indexTip).location,
              let thumbTip = try? observation.recognizedPoint(.thumbTip).location else {
                  return nil
              }
        self.top = indexTip
        self.bottom = thumbTip
    }
}

extension Pinch {
    static var example: Pinch {
        Pinch(top: CGPoint(x: 0.5, y: 0.4), bottom: CGPoint(x: 0.55, y: 0.55))
    }
}
