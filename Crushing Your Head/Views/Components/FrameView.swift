//
//  FrameView.swift
//  FrameView
//
//  Created by Yonatan Mittlefehldt on 2021-21-07.
//

import SwiftUI

struct FrameView: View {
    var image: CGImage?

    private let label = Text("Camera feed")

    var body: some View {
        if let image = image {
            Image(image, scale: 1.0, orientation: .up, label: label)
                .resizable()
                .scaledToFill()
        } else {
            Color.black
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        FrameView(image: nil)
    }
}
