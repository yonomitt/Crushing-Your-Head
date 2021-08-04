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

    var isClosed: Bool {
        abs(top.y - bottom.y) <= 0.03
    }

    var isOpen: Bool {
        !isClosed
    }

    private init(top: CGPoint, bottom: CGPoint) {
        self.top = top
        self.bottom = bottom
    }

    init?(from observation: VNHumanHandPoseObservation) {
        guard let indexTip = try? observation.recognizedPoint(.indexTip),
              let thumbTip = try? observation.recognizedPoint(.thumbTip) else {
                  return nil
              }

        guard indexTip.confidence >= 0.8,
              thumbTip.confidence >= 0.8 else {
                  return nil
              }

        self.top = indexTip.location
        self.bottom = thumbTip.location
    }
}

extension Pinch {
    static var example: Pinch {
        Pinch(top: CGPoint(x: 0.5, y: 0.4), bottom: CGPoint(x: 0.55, y: 0.55))
    }
}
