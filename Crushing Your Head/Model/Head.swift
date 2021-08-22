//
//  Head.swift
//  Head
//
//  Created by Yonatan Mittlefehldt on 2021-27-07.
//

import CoreGraphics
import Foundation

/// A strutcure representing a head, which may or may not be crushed
/// The `id` is used to track the head across consecutive frames
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
