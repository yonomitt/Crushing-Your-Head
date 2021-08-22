//
//  DetectedObject.swift
//  DetectedObject
//
//  Created by Yonatan Mittlefehldt on 2021-20-08.
//

import CoreGraphics
import Foundation

/// A structure representing an object detected by a Vision request
struct DetectedObject: Identifiable {
    let id: UUID
    let bbox: CGRect
}
