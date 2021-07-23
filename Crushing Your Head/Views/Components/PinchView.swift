//
//  PinchView.swift
//  PinchView
//
//  Created by Yonatan Mittlefehldt on 2021-23-07.
//

import SwiftUI

struct PinchView: View {
    var pinch: Pinch?
    let pointSize: CGFloat = 6

    var body: some View {
        GeometryReader { geo in
            if let top = pinch?.top,
               let bottom = pinch?.bottom {
                Path { path in
                    path.addEllipse(in: self.rect(for: top, within: geo.frame(in: .local)))
                    path.addEllipse(in: self.rect(for: bottom, within: geo.frame(in: .local)))
                }
                .foregroundColor(.red)
            } else {
                EmptyView()
            }
        }
    }

    private func rect(for tip: CGPoint, within rect: CGRect) -> CGRect {
        let scaledPoint = point(for: tip, within: rect)
        return CGRect.centered(at: scaledPoint, with: pointSize)
    }

    private func point(for tip: CGPoint, within rect: CGRect) -> CGPoint {
        (tip.mirrorY * rect.size) + rect.origin
    }
}

struct PinchView_Previews: PreviewProvider {
    static var previews: some View {
        PinchView(pinch: Pinch.example)
    }
}
