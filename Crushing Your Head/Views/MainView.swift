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
            FrameView(image: model.frame)
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
