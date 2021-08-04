//
//  HUDView.swift
//  HUDView
//
//  Created by Yonatan Mittlefehldt on 2021-04-08.
//

import SwiftUI

struct HUDView: View {
    var score: Int
    var body: some View {
        VStack {
            HStack {
                Spacer()

                HStack {
                    Text("SCORE:")
                        .fontWeight(.bold)

                    Text("\(score)")
                        .fontWeight(.bold)
                        .frame(width: 75, alignment: .trailing)
                }
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 0)
                .padding(.horizontal)
            }

            Spacer()
        }
    }
}

struct HUDView_Previews: PreviewProvider {
    static var previews: some View {
        HUDView(score: 999999)
    }
}
