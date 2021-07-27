//
//  HeadView.swift
//  HeadView
//
//  Created by Yonatan Mittlefehldt on 2021-27-07.
//

import SwiftUI

struct HeadView: View {
    var heads: [Head]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(heads) { head in
                    Path { path in
                        path.addRect(rect(for: head.bbox, within: geo.frame(in: .local)))
                    }
                    .stroke(Color.yellow, lineWidth: 6)
                }
            }
        }
    }

    private func rect(for bbox: CGRect, within rect: CGRect) -> CGRect {
        let size = bbox.size * rect.size
        let origin = bbox.origin.mirrorY * rect.size + rect.origin - CGPoint(x: 0, y: size.height)
        return CGRect(origin: origin, size: size)
    }
}

struct HeadView_Previews: PreviewProvider {
    static var previews: some View {
        HeadView(heads: [])
    }
}
