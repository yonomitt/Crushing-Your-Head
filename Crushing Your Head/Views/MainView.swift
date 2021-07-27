//
//  MainView.swift
//  Crushing Your Head
//
//  Created by Yonatan Mittlefehldt on 2021-21-07.
//

import SwiftUI

struct MainView: View {
    @StateObject private var model = MainViewModel()

    var body: some View {
        ZStack {
            GeometryReader { geo in
                ZStack {
                    FrameView(image: model.frame)

                    HeadView(heads: model.heads)

                    PinchView(pinch: model.pinch)
                }
                .frame(width: geo.size.width,
                       height: geo.size.height,
                       alignment: .center)
                .clipped()
            }
            .edgesIgnoringSafeArea(.all)

            ErrorView(error: model.error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
