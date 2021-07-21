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
            GeometryReader { geo in
                Image(image, scale: 1.0, orientation: .up, label: label)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width,
                           height: geo.size.height,
                           alignment: .center)
                    .clipped()
            }
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
