//
//  StatView.swift
//  TikQuiz
//
//  Created by István Kreisz on 1/6/21.
//

import SwiftUI

struct StatView: View {
    let title: String
    let correctCount: Int
    let wrongCount: Int
    let notAnsweredCount: Int
    let isFullScreen: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: isFullScreen ? nil : 140, height: 140, alignment: .center)
                .foregroundColor(Color.white.opacity(0.1))
                .cornerRadius(15)

            VStack(spacing: 15) {
                Text(title)
                    .font(.bold(size: 15))
                    .foregroundColor(.white)
                Text(title)
                    .font(.regular(size: 18))
                    .foregroundColor(.white)
            }
        }
    }
}

struct StatView_Previews: PreviewProvider {
    static var previews: some View {
        StatView(title: "title", correctCount: 1, wrongCount: 2, notAnsweredCount: 3, isFullScreen: false)
    }
}
