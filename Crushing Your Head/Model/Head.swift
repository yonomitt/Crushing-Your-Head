//
//  Head.swift
//  Head
//
//  Created by Yonatan Mittlefehldt on 2021-27-07.
//

import CoreGraphics
import Foundation

struct Head: Identifiable {
    let id: UUID
    let bbox: CGRect
    let crushed: Bool
    
    init(detectedObject: DetectedObject, crushed: Bool) {
        self.id = detectedObject.id
        self.bbox = detectedObject.bbox
        self.crushed = crushed
    }
}
