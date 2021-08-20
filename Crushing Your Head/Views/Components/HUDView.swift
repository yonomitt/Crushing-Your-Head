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
                Text("SCORE:")
                    .font(.system(size: 100, weight: .semibold))

                Spacer()
                
                Text("\(score)")
                    .font(.system(size: 100, weight: .semibold))
                    .frame(width: 200, alignment: .trailing)
            }
            .foregroundColor(.white)
            .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 0)
            .padding(.horizontal, 50)

            Spacer()
        }
    }
}

struct HUDView_Previews: PreviewProvider {
    static var previews: some View {
        HUDView(score: 999999)
    }
}
