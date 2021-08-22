//
//  DetectedObject.swift
//  DetectedObject
//
//  Created by Yonatan Mittlefehldt on 2021-20-08.
//

import CoreGraphics
import Foundation

struct DetectedObject: Identifiable {
    let id: UUID
    let bbox: CGRect
}
