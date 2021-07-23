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

    init?(from observation: VNHumanHandPoseObservation) {
        guard let indexTip = try? observation.recognizedPoint(.indexTip).location,
              let thumbTip = try? observation.recognizedPoint(.thumbTip).location else {
                  return nil
              }
        self.top = indexTip
        self.bottom = thumbTip
    }
}
