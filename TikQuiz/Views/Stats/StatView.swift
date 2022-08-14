//
//  StatView.swift
//  TikQuiz
//
//  Created by István Kreisz on 1/6/21.
//

import SwiftUI

struct StatView: View {
    private let medalSize: CGFloat = .init(adaptiveSize: 20)

    let bestStreakCount: Int
    let correctCount: Int
    let wrongCount: Int

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Best streak: \(bestStreakCount)")
                    .font(.semiBold(size: .init(adaptiveSize: 20)))
                    .foregroundColor(.white)
                // todo: test
                if let medal = Medal(bestStreakCount: bestStreakCount) {
                    Image(medal.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: medalSize)
                }
            }

            Text("Correct guesses: \(correctCount)")
                .font(.semiBold(size: .init(adaptiveSize: 20)))
                .foregroundColor(.white)

            Text("Wrong guesses: \(wrongCount)")
                .font(.semiBold(size: .init(adaptiveSize: 20)))
                .foregroundColor(.white)
        }
    }
}
